require 'test_helper'

class ImportJobTest < ActiveSupport::TestCase
  test "should create a valid import job" do
    import_job = ImportJob.new(
      start_time: Time.current,
      status: :started,
      raw_json: '{"test": "new data"}'
    )
    assert import_job.save
  end

  test "should read an import job" do
    job = import_jobs(:started_job)
    found_job = ImportJob.find(job.id)
    assert_equal job.start_time.to_i, found_job.start_time.to_i
    assert_equal job.status, found_job.status
    assert_equal job.raw_json, found_job.raw_json
  end

  test "should update an import job" do
    job = import_jobs(:started_job)
    assert job.update(status: :completed, end_time: Time.current)
    job.reload
    assert_equal "completed", job.status
    assert_not_nil job.end_time
  end

  test "should destroy an import job" do
    job = import_jobs(:started_job)
    log_ids = job.import_logs.pluck(:id)

    assert_difference('ImportJob.count', -1) do
      assert_difference('ImportLog.count', -job.import_logs.count) do
        job.destroy
      end
    end

    # Ensure all associated logs are destroyed
    log_ids.each do |log_id|
      assert_raises(ActiveRecord::RecordNotFound) do
        ImportLog.find(log_id)
      end
    end
  end

  test "should have correct enum values for status" do
    assert_equal ImportJob.statuses.keys, ["started", "completed", "failed", "error"]
  end

  test "should calculate duration correctly" do
    job = import_jobs(:completed_job)
    assert_in_delta 1.hour.to_i, job.duration.to_i, 1
  end

  test "should return nil for duration if end_time is not set" do
    job = import_jobs(:started_job)
    assert_nil job.duration
  end

  test "can have have many import_logs" do
    job = import_jobs(:started_job)
    assert_respond_to job, :import_logs
  end
end
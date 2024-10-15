require 'test_helper'

class ImportLogTest < ActiveSupport::TestCase
  test "should create a valid import log" do
    import_log = ImportLog.new(
      import_job: import_jobs(:started_job),
      entity: 'menu_item',
      name: 'New Item',
      status: :success,
      message: 'New item imported'
    )
    assert import_log.save
  end

  test "should read an import log" do
    log = import_logs(:success_log)
    found_log = ImportLog.find(log.id)
    assert_equal log.entity, found_log.entity
    assert_equal log.name, found_log.name
    assert_equal log.status, found_log.status
    assert_equal log.message, found_log.message
  end

  test "should update an import log" do
    log = import_logs(:success_log)
    assert log.update(status: :fail, message: 'Import failed')
    log.reload
    assert_equal "fail", log.status
    assert_equal 'Import failed', log.message
  end

  test "should destroy an import log" do
    log = import_logs(:success_log)
    assert_difference('ImportLog.count', -1) do
      log.destroy
    end
  end

  test "should be invalid without import_job" do
    log = import_logs(:success_log)
    log.import_job = nil
    assert_not log.valid?
  end

  test "should be invalid without entity" do
    log = import_logs(:success_log)
    log.entity = nil
    assert_not log.valid?
  end

  test "should be invalid without name" do
    log = import_logs(:success_log)
    log.name = nil
    assert_not log.valid?
  end

  test "should be invalid without status" do
    log = import_logs(:success_log)
    log.status = nil
    assert_not log.valid?
  end

  test "should be invalid without message" do
    log = import_logs(:success_log)
    log.message = nil
    assert_not log.valid?
  end

  test "should have correct enum values for status" do
    assert_equal ImportLog.statuses.keys, ["success", "fail"]
  end

  test "should belong to import_job" do
    log = import_logs(:success_log)
    assert_respond_to log, :import_job
  end
end
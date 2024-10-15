class ImportJob < ApplicationRecord
  has_many :import_logs, dependent: :destroy

  validates :status, presence: true
  validates :raw_json, presence: true

  enum status: { started: 0, completed: 1, failed: 2, error: 3 }

  def duration
    return nil unless end_time && start_time
    end_time - start_time
  end
end
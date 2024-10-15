class ImportLog < ApplicationRecord
  belongs_to :import_job

  validates :entity, presence: true
  validates :name, presence: true
  validates :status, presence: true
  validates :message, presence: true

  enum status: { success: 0, fail: 1 }
end
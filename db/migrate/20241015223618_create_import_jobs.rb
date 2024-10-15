class CreateImportJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :import_jobs do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.integer :status, null: false, default: 0
      t.text :raw_json, null: false

      t.timestamps
    end
  end
end
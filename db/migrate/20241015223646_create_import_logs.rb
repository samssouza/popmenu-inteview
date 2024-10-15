class CreateImportLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :import_logs do |t|
      t.references :import_job, null: false, foreign_key: true
      t.string :entity, null: false
      t.string :name, null: false
      t.integer :status, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
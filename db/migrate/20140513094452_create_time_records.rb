class CreateTimeRecords < ActiveRecord::Migration
  def change
    create_table :time_records do |t|
      t.references :user
      t.references :project
      t.datetime :recorded_at
      t.datetime :recorded_on
      t.decimal :value, precision: 20, scale: 2

      t.timestamps
    end
    add_index :time_records, :user_id
    add_index :time_records, :project_id
  end
end

class CreateTimeSheets < ActiveRecord::Migration
  def change
    create_table :time_sheets do |t|
      t.references :user
      t.references :project
      t.decimal :recorded_value, precision: 20, scale: 2, default: 0
      t.decimal :overtime_value, precision: 20, scale: 2, default: 0
      t.decimal :calculated_value, precision: 20, scale: 2, default: 0
      t.datetime :recorded_on

      t.timestamps
    end
    add_index :time_sheets, :user_id
    add_index :time_sheets, :project_id
  end
end

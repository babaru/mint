class CreateOvertimeRecords < ActiveRecord::Migration
  def change
    create_table :overtime_records do |t|
      t.references :user
      t.datetime :happened_at
      t.decimal :value, precision: 20, scale: 2, default: 0

      t.timestamps
    end
    add_index :overtime_records, :user_id
  end
end

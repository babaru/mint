class AddOvertimeRecordsTimeSheetId < ActiveRecord::Migration
  def up
    add_column :overtime_records, :time_sheet_id, :integer
    add_index :overtime_records, :time_sheet_id
  end

  def down
    remove_index :overtime_records, :time_sheet_id
    remove_column :overtime_records, :time_sheet_id
  end
end

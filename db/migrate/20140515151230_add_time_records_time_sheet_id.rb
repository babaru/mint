class AddTimeRecordsTimeSheetId < ActiveRecord::Migration
  def up
    add_column :time_records, :time_sheet_id, :integer
    add_index :time_records, :time_sheet_id
  end

  def down
    remove_index :time_records, :time_sheet_id
    remove_column :time_records, :time_sheet_id
  end
end

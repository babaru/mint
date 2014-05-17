class ChangeTimeSheetColumns < ActiveRecord::Migration
  def up
    rename_column :time_sheets, :recorded_value, :recorded_hours
    rename_column :time_sheets, :overtime_value, :overtime_hours
    rename_column :time_sheets, :calculated_value, :calculated_hours
    add_column :time_sheets, :calculated_normal_hours, :decimal, precision: 20, scale: 2
    add_column :time_sheets, :calculated_overtime_hours, :decimal, precision: 20, scale: 2
  end

  def down
    rename_column :time_sheets, :recorded_hours, :recorded_value
    rename_column :time_sheets, :overtime_hours, :overtime_value
    rename_column :time_sheets, :calculated_hours, :calculated_value
    remove_column :time_sheets, :calculated_normal_hours
    remove_column :time_sheets, :calculated_overtime_hours
  end
end

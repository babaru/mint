class AddTimeRecordsTaskType < ActiveRecord::Migration
  def up
    add_column :time_records, :task_type_id, :integer
    add_index :time_records, :task_type_id
  end

  def down
    remove_index :time_records, :task_type_id
    remove_column :time_records, :task_type_id
  end
end

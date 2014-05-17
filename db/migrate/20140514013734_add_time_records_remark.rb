class AddTimeRecordsRemark < ActiveRecord::Migration
  def up
    add_column :time_records, :remark, :string
  end

  def down
    remove_column :time_records, :remark
  end
end

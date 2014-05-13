class RemoveTimeRecordsRecordedAt < ActiveRecord::Migration
  def up
    remove_column :time_records, :recorded_at
  end

  def down
    add_column :time_records, :recorded_at, :datetime
  end
end

class TimeRecordsAddStartedAtEndedAt < ActiveRecord::Migration
  def up
    add_column :time_records, :started_at, :datetime
    add_column :time_records, :ended_at, :datetime
  end

  def down
    remove_column :time_records, :started_at
    remove_column :time_records, :ended_at
  end
end

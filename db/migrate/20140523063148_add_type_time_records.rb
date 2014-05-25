class AddTypeTimeRecords < ActiveRecord::Migration
  def up
    add_column :time_records, :type, :string

    TimeRecord.transaction do
      TimeRecord.all.each do |record|
        record.type = TimeRecord.class
        record.save!
      end
    end
  end

  def down
    remove_column :time_records, :type
  end
end

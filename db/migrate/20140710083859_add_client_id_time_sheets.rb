class AddClientIdTimeSheets < ActiveRecord::Migration
  def up
    add_column :time_sheets, :client_id, :integer
    add_index :time_sheets, :client_id
  end

  def down
    remove_index :time_sheets, :client_id
    remove_column :time_sheets, :client_id
  end
end

class AddProjectParent < ActiveRecord::Migration
  def up
    add_column :projects, :parent_id, :integer
    add_index :projects, :parent_id
  end

  def down
    remove_index :projects, :parent_id
    remove_column :projects, :parent_id
  end
end

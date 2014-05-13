class CreateUserUserGroups < ActiveRecord::Migration
  def change
    create_table :user_user_groups do |t|
      t.references :user
      t.references :user_group

      t.timestamps
    end
    add_index :user_user_groups, :user_id
    add_index :user_user_groups, :user_group_id
  end
end

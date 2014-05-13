class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.datetime :started_at
      t.datetime :ended_at
      t.string :key
      t.references :client
      t.string :type
      t.integer :level

      t.timestamps
    end
    add_index :projects, :client_id
  end
end

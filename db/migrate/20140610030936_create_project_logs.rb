class CreateProjectLogs < ActiveRecord::Migration
  def change
    create_table :project_logs do |t|
      t.string :type
      t.datetime :recorded_on
      t.string :remark
      t.references :project

      t.timestamps
    end
    add_index :project_logs, :project_id
  end
end

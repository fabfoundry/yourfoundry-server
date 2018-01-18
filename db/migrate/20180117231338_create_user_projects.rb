class CreateUserProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :user_projects do |t|
      t.integer :user_id
      t.integer :project_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end

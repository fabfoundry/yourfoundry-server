class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end

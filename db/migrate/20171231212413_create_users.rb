class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :company_name
      t.string :password_digest
      t.string :role, :default => "startup"
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end

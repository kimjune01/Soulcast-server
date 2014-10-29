class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.boolean :verified, :default => false
      t.string :token, :unique

      t.timestamps null: false
    end
  end
end

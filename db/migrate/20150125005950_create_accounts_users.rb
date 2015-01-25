class CreateAccountsUsers < ActiveRecord::Migration
  def change
    create_table :accounts_users do |t|
      t.references :account
      t.references :user
      t.string :role

      t.timestamps
    end
      # Add table index
      add_index :accounts_users, [:account_id, :user_id], :unique => true
  end
end

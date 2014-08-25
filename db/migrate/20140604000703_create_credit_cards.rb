class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.text :name
      t.decimal :credit_limit
      t.decimal :interest_rate
      t.decimal :balance_transfer_fee
      t.integer :no_interest_months
      t.decimal :foreign_transaction_fee
      t.text :url
      t.integer :notes_id

      t.timestamps
    end
  end
end

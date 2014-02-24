class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :account_id
      t.datetime :payment_date
      t.boolean :is_recurring

      t.timestamps
    end
  end
end

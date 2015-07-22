class AddPaymentAmountToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :payment_amount, :decimal
  end
end

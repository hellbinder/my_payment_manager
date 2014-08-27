class AddAmountAndReferenceToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :amount, :decimal
    add_column :payments, :reference, :text
  end
end

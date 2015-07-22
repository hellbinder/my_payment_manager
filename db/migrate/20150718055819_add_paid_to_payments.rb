class AddPaidToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :paid, :boolean, null: false, default: false
  end
end

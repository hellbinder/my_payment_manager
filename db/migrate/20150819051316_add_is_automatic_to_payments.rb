class AddIsAutomaticToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :automatic, :boolean, default: false
  end
end

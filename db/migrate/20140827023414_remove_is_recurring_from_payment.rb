class RemoveIsRecurringFromPayment < ActiveRecord::Migration
  def change
    remove_column :payments, :is_recurring
  end
end

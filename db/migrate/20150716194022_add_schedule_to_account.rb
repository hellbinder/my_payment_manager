class AddScheduleToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :schedule, :text
  end
end

class AddHomepageToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :homepage, :text
  end
end

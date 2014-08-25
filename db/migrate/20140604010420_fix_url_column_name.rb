class FixUrlColumnName < ActiveRecord::Migration
  def change
    rename_column :credit_cards, :url, :homepage
  end
end

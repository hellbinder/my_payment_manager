class RemoveNoteIdFromCreditCards < ActiveRecord::Migration
  def change
    remove_column :credit_cards, :notes_id, :integer
  end
end

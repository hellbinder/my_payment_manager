class AddNoteableToNotes < ActiveRecord::Migration
  def change
    add_reference :notes, :noteable, polymorphic: true, index: true
  end
end

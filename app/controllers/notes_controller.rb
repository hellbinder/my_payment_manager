class NotesController < ApplicationController
  def create
    @note = Note.new(note_params)
    respond_to do |format|
      if @note.save
        format.html { redirect_to(public_send("#{@note.noteable_type.downcase.pluralize}_path"), notice: "Note was added successfully.")}
        format.js { render layout: false }
      else
        format.html { 
          redirect_to(public_send("#{@note.noteable_type.downcase.pluralize}_path"), error: "Error when saving account")
          # redirect_to new_payment_path
        }
      end
    end
  end

  private
  def note_params
      params.require(:note).permit(:title, :detail, :noteable_type, :noteable_id)
  end
end
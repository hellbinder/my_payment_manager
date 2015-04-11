module NotesHelper
  def notes_for(model)
   create_form + 
   render(model.notes)
  end

  private
  def create_form
    form_for Note.new, method: :post do |f|
      haml_concat f.label :title 
      haml_concat f.text_field :title
      haml_concat f.label :detail
      haml_concat f.text_field :detail
      haml_concat f.submit value: "Add", data: { disable_with: 'Adding...' }
    end
  end
end
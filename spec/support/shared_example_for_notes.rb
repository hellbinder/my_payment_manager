require 'spec_helper'

# THIS WOULD NOT WORK..shared examples run on every set of tests (on every describe)
shared_examples 'a noteable model' do
  describe "notes operations" do
    before do
      5.times do |n|
        model.notes << FactoryGirl.create(:note)
      end
      visit public_send("#{model.class.to_s.downcase}_path", model)
    end
    it { expect(page).to have_css "#notes-tab"}

    feature "create" do
      scenario "all fields entered", js: true do
        create_note("Note #1", "This is a description")

        expect(page).to have_css ".list-group-item-text", text: "This is a description"       
      end

      scenario "fields missing", js: true do
        create_note("", "")

        expect(page).to have_css ".alert.alert-danger > li", text: "Detail can't be blank"
        expect(page).to have_css ".alert.alert-danger > li", text: "Title can't be blank"
      end
    end
  end 
end

private 

def create_note(title, description)
  first('#notes-tab > a').click
  fill_in "note_title", with: title
  fill_in "note_detail", with: description

  click_button "Add"
end
require 'spec_helper'

describe "Home Pages" do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  describe "index page" do
    before :each do
      visit root_path
    end
    it "should display the links in the page" do
      expect(page).to have_link "Credit Cards", credit_cards_path
    end
  end
end
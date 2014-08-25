require 'spec_helper'

describe "credit_cards/index.html.haml" do
  subject {page}
  context "with 2 widgets" do
    before(:each) do
      assign(:credit_cards, [
        FactoryGirl.create(:credit_card, name: "cc1"),
        FactoryGirl.create(:credit_card, name: "cc2")
      ])
    end

    it "displays both widgets" do
      render
      expect(rendered).to match /cc1/
      expect(rendered).to match /cc2/
    end
  end
end

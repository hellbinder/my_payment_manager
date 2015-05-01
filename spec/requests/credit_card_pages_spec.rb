require 'spec_helper'

describe "Credit Card Pages" do
  subject { page }

  #index
  describe "index" do
    before do
      5.times { FactoryGirl.create :credit_card }
      visit credit_cards_path
    end

    it { is_expected.to have_selector "h1", text: "All Credit Cards" }

    context "credit cards table" do
      it "should show all credit cards" do
        CreditCard.all.each do |cc|
          expect(page).to have_content, cc.name
          expect(page).to have_content cc.homepage
          expect(page).to have_content, cc.interest_rate.to_s
        end
      end
    end
    # it "should have notes for each card"
  end
end
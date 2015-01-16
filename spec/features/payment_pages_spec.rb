require "spec_helper"

describe "Account Pages" do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  before do
    sign_in user
  end

  context "Create payment" do
    let(:account) { FactoryGirl.create :account, name: "Bestbuy" }
    before { visit new_account_payment_path(account) }
    it { is_expected.to have_selector "h1", text: "New payment"}
    it { is_expected.to have_field("Amount") }
    it { is_expected.to have_field("Payment Date") }

    it "should save successfully and redirect to account page when posting" do
      select "Bestbuy", from: "Account" #infers a drop down is there with the value
      fill_in "payment_amount", with: "140"
      fill_in "payment_payment_date", with: "1/5/2014"
      click_button "Create"
      
      expect(page).to have_selector "h4", text: "#{account.name}"
      expect(page).to have_success_message "Payment was successfully created"
    end

    it "should not save when account is not selected" do
      select "", from: "Account"
      fill_in "payment_amount", with: "140.45"
      fill_in "payment_payment_date", with: "1/5/2014"
      click_button "Create"
      expect(page).to have_error_message "There was an error creating the payment"
    end
  end
end
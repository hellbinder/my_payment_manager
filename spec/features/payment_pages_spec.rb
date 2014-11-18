require "spec_helper"

describe "Account Pages" do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  before do
    sign_in user
    @account = FactoryGirl.create :account
  end

  describe "Payment new page" do
    before { visit new_account_payment_path(@account) }
    it { is_expected.to have_selector "h1", text: "New payment for #{@account.name}" }
    it {is_expected.to have_field("Amount")}
    it {is_expected.to have_field("Payment Date")}

    it "should redirect to account page when posting payment" do
      fill_in "payment_amount", with: "140"
      fill_in "payment_payment_date", with: "1/5/2014"
      click_button "Create"

      expect(page).to have_success_message "Payment was successfully created"
    end
  end
end
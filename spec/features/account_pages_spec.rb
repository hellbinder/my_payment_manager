require 'spec_helper'

describe "Account Pages" do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  describe "index page" do
    before :each do
      2.times { FactoryGirl.create :account }
      visit accounts_path
    end
    it { is_expected.to have_selector "h1", text: "Your Accounts" }
    it "should display the accounts in the page" do
      Account.all.each do |account|
        expect(page).to have_link account.name, href: account_path(account)
        expect(page).to have_selector "td", text: account.description
      end
    end
  end

  describe "show page" do
    before do
      @payment = FactoryGirl.create :payment
      @account = FactoryGirl.create :account
      @account.payments << @payment
      visit account_path @account
    end

    it { is_expected.to have_selector "h4",text: @account.name}

    it "should show history of payments" do
      click_link "View Details"
      expect(page).to have_selector "td", text: @payment.payment_date.strftime("%D")
      expect(page).to have_selector "td", text: @payment.amount
    end
  end

  describe "create page" do
    before { visit new_account_path }
    let(:new_account) { FactoryGirl.build :account }
    it { is_expected.to have_selector "h1", text: "New Account" }
    it {is_expected.to have_field("Homepage")}
    it {is_expected.to have_field("Name")}
    it {is_expected.to have_field("Description")}

    it "should save the account with the correct information" do
      fill_in "account_name", with: new_account.name
      fill_in "account_description", with: new_account.description
      fill_in "account_homepage", with: new_account.homepage

      click_button "Create"
      expect(page).to have_success_message "Account was successfully created"
    end

    it "should give and error when the information is incorrect" do
      fill_in "account_name", with: ""
      fill_in "account_description", with: new_account.description

      click_button "Create"

      puts page.current_url
      expect(page).to have_error_message "There was an error creating the account" 
    end

      # PAYMENTS

    describe "payments page from account" do
      let(:account) { FactoryGirl.create(:account) }
      it "should have the link to the payments page" do
        puts new_account_payment_url(account)
        expect(page).to have_text("Make a payment")˜
      end
    end
  end
end
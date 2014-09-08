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
    before(:each) do
      @payment = FactoryGirl.create :payment
      @account = FactoryGirl.create :account
      @account.payments << @payment
      visit account_path @account
    end

    it { is_expected.to have_content @account.name}

    it "should show history of payments" do
      @account.payments do |payment|
        expect(page).to have_link account.name, href: payment_path(payment)
        expect(page).to have_selector "td", text: payment.description
      end
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
  end
end
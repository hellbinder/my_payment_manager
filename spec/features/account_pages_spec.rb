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

    it { is_expected.to have_selector "h1", text: @account.name}

    it "should show history of payments" do
      @account.payments do |payment|
        expect(page).to have_link account.name, href: payment_path(payment)
        expect(page).to have_selector "td", text: payment.description
      end
    end
  end

end
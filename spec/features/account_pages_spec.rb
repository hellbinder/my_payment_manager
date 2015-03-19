require 'spec_helper'

describe "Account Pages" do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  describe "index page" do
    before :each do
      #owner account
      @owner_account = FactoryGirl.create :account, name: "Owner Account"
      @owner_account.user_roles.create(user: user, role: "owner")

      #not being owner
      other_user = FactoryGirl.create :user
      @user_member_account = FactoryGirl.create :account, name: "User member account"

      #add users to account roles
      @user_member_account.user_roles.create(user: other_user, role: "owner")
      @user_member_account.user_roles.create(user: user, role: "member")

      #other_user account only
      @other_user_account = FactoryGirl.create :account, name: "Other user account"
      @other_user_account.user_roles.create(user: other_user, role: "owner")

      visit accounts_path
    end

    it { is_expected.to have_selector "h1", text: "Your Accounts" }

    it "displays the accounts created by the user and shared by others" do
      #owner account
      expect(page).to have_link @owner_account.name, href: account_path(@owner_account)
      expect(page).to have_selector "td", text: @owner_account.description

      #account shared to owner
      expect(page).to have_link @user_member_account.name, href: account_path(@user_member_account)
      expect(page).to have_selector "td", text: @user_member_account.description
    end

    it "does not display accounts that are not associated with the user" do
      expect(page).to_not have_link @other_user_account.name, href: account_path(@other_user_account)
      expect(page).to_not have_selector "td", text: @other_user_account.description
    end
  end

  context "show" do
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

  context "create" do
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

    it "give an error when the information is incorrect" do
      fill_in "account_name", with: ""
      fill_in "account_description", with: new_account.description

      click_button "Create"

      expect(new_account.owner).to eq ""
      expect(page).to have_error_message "There was an error creating the account" 
    end

    it "should have the user who created the account as the owner"
  end

  context "payments page" do
    let(:account) { FactoryGirl.create :account }
    before { visit accounts_path }
    it "should have a link to the payments page from the index" do
      expect(page).to have_link("Make a payment", new_payment_path)
    end
    it "should show the payment page" do
      click_link "Make a payment"
      expect(page).to have_selector "h1", text: "New payment"
    end
  end

  context "edit/update" do
    let(:old_account) { FactoryGirl.create :account, name: "Account1", description: "Some description", homepage: "http://www.google.com"}
    before { visit edit_account_path old_account }
    it { is_expected.to have_selector "h1", text: "Edit Account1" }
    it { is_expected.to have_field("Name", with: "Account1" )}
    it { is_expected.to have_field("Description", with: "Some description" )}
    it { is_expected.to have_field("Homepage", with: "http://www.google.com" )}
    it "should save the updated account and go back to the accounts page" do
      fill_in "Name", with: "Account2"
      click_button "Update"
      expect(current_url).to eq(accounts_url)
      expect(page).to have_success_message "Account was successfully updated"
      expect(page).to have_selector 'a', text:  "Account2"
    end
  end

  describe "delete account from show page" do
    let(:account) { FactoryGirl.create :account } 
    before { visit account_path account }

    it "should delete the account" do
      expect { click_link "Delete" }.to change(Account, :count).by(-1)
    end

    it "should redirect to the index page with the success message" do
      click_link "Delete"
      expect(page.current_url).to eq(accounts_url)
      expect(page).to have_success_message "The account was deleted successfully"
    end
  end
end

=begin
  describe "delete from index page", js:true do
    before do
      5.times do |n|
        FactoryGirl.create :account
      end
      visit accounts_path
    end
    let(:account_to_delete) { Account.first } 

    it "should be able to delete the account" do
      page.find("#account_#{account_to_delete.id} td:last").click
      wait_for_ajax
    end
  end
=end
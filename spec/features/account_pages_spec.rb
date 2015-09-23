require 'spec_helper'
include NotesHelper
# require 'support/shared_example_for_notes'

describe "Account Pages" do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  context "index page" do
    before :each do
      create_account_and_roles

      visit accounts_path
    end

    it { is_expected.to have_selector "h1", text: "Your Accounts" }

    it "displays the accounts created by the user and shared by others" do
      #owner account
      expect(page).to have_link @owner_account.name, href: account_path(@owner_account)
      expect(page).to have_selector "td", text: @owner_account.description

      #account shared by owner
      expect(page).to have_link @user_member_account.name, href: account_path(@user_member_account)
      expect(page).to have_selector "td", text: @user_member_account.description
    end

    it "does not display accounts that are not associated with the user" do
      expect(page).to_not have_link @other_user_account.name, href: account_path(@other_user_account)
      expect(page).to_not have_selector "td", text: @other_user_account.description
    end
  end

  describe "show" do
    context "when authorized" do
      before do
        @payment = FactoryGirl.create :payment, amount: 500
        @paid_payment = FactoryGirl.create :paid_payment, amount: 300, payment_date: Date.today
        @account = FactoryGirl.create :account
        @account.add_owner(user)
        @account.payments << @paid_payment
        @account.payments << @payment
        visit account_path @account
      end

      it { is_expected.to have_selector "h2",text: @account.name}
      it { is_expected.to have_selector "#payments" }
      it { is_expected.to have_link "Back", accounts_path }
      it { is_expected.to have_text "Total amount for current month" }
      it { is_expected.to have_selector "#monthly_amount", text: "300"}

      it "only shows history of paid payments" do
        click_link "View Details"
        expect(page).to have_selector "td", text: @paid_payment.payment_date.strftime("%D")
        expect(page).to have_selector "td", text: @paid_payment.amount
        #Unpaid should not show
        expect(page).to_not have_selector "td", text: @payment.payment_date.strftime("%D")
        expect(page).to_not have_selector "td", text: @payment.amount
      end
    end

    context "when unauthorized" do
      before do
        @account = FactoryGirl.create :account
        visit account_path @account
      end
      it "redirects the user to the accounts page" do
        expect(current_path).to eq accounts_path
      end
      it {is_expected.to have_error_message "You are not authorized to view this account"}
    end
    
    context "having recurring payment" do
      before do
        new_time = Time.local(2015, 1, 13, 12, 0, 0)
        Timecop.freeze(new_time)
        @recurring_account = FactoryGirl.create :recurring_account
        @recurring_account.add_owner(user)
        visit account_path @recurring_account
      end
      after do
        Timecop.return
      end
      it { is_expected.to have_text "This account has automatic payment creation set up" }
      it "shows 1/15/2015 as the next payment with $450 when current date is 01/13/2015" do
        expect(page).to have_css "div.h4", text: "$450.00 on 01/15/2015"
      end
    end
  end

  context "create" do
    before { visit new_account_path }
    let(:new_account) { FactoryGirl.build :account }
    it { is_expected.to have_selector "h1", text: "New Account" }
    it {is_expected.to have_field("Homepage")}
    it {is_expected.to have_field("Name")}
    it {is_expected.to have_field("Description")}
    it { is_expected.to have_select("Schedule", text: "- not recurring -" )}


    it "should save the account with the correct information" do
      fill_in "account_name", with: new_account.name
      fill_in "account_description", with: new_account.description
      fill_in "account_homepage", with: new_account.homepage

      click_button "Create"
      expect(page).to have_success_message "Account was successfully created"
    end

    it "gives an error when the information is incorrect" do
      fill_in "account_name", with: ""
      fill_in "account_description", with: new_account.description

      click_button "Create"

      expect(page).to have_error_message "Error creating an account"
    end
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

  describe "edit/update" do 
    before { @old_account =  FactoryGirl.create :account, name: "Account1",
     description: "Some description",
     homepage: "http://www.google.com",
     schedule: IceCube::Rule.monthly.day_of_month(1).to_hash,
     payment_amount: 450
     }
    context "when not authorized" do
      before { visit edit_account_path @old_account }
      it "redirects to the account page with an unauthorized message" do
        expect(current_path).to eq(accounts_path)
        expect(page).to have_error_message "You are not authorized to edit this account"
      end
    end
    context "when authorized" do      
      before  do
        @old_account.add_owner user
        visit edit_account_path @old_account
      end
      it { is_expected.to have_selector "h1", text: "Edit Account1" }
      it { is_expected.to have_field("Name", with: "Account1" )}
      it { is_expected.to have_field("Description", with: "Some description" )}
      it { is_expected.to have_field("Homepage", with: "http://www.google.com" )}
      it { is_expected.to have_field("Payment amount", with: "450.00" )} #didn't work because it's case sensitive (had Payment Amount)
      it { is_expected.to have_select("Schedule", text: "Monthly on the 1st day of the month*" )}
      it "should save the updated account and go back to the account page" do
        fill_in "Name", with: "Account2"
        click_button "Update"
        expect(current_path).to eq(account_path @old_account)
        expect(page).to have_success_message "Account was successfully updated"
        expect(page).to have_selector 'h2', text:  "Account2"
      end
    end
  end

  describe "delete account from show page" do
    let(:account) { FactoryGirl.create :account } 
    before do 
      account.add_owner user
      visit account_path account
    end

    it "should delete the account" do
      expect { click_link "Delete" }.to change(Account, :count).by(-1)
    end

    it "should redirect to the index page with the success message" do
      click_link "Delete"
      expect(page.current_path).to eq(accounts_path)
      expect(page).to have_success_message "The account was deleted successfully"
    end
  end

  describe "account authorization" do
    before { create_account_and_roles }

    describe "user visits his owned account" do
      before { visit account_path @owner_account }
      it "should have the button to delete" do 
        expect(page).to have_link "Delete"
      end

       it { is_expected.to have_link "Edit", edit_account_path(@owner_account) }
       it { is_expected.to have_link "Manage Security", account_security_path(@owner_account) }

    end

    describe "user visits account he's a member of" do
      before { visit account_path @user_member_account }
      it "should not have the option to delete" do 
        expect(page).to_not have_link "Delete"
      end
       it { is_expected.not_to have_link "Edit", edit_account_path(@owner_account) }

    end

    describe "user visits an account he can only view" do
      before { visit account_path @other_user_account }
      it "should not have the option to delete" do 
        expect(page).to_not have_link "Delete"
      end
       it { is_expected.not_to have_link "Edit", edit_account_path(@owner_account) }
    end

    describe "edit account authorization", js: true do
      #TODO: Finish testing authorization here
      before do
        visit edit_account_path @owner_account
        find("li a[href='#security']").click
      end
      it { is_expected.to have_text "User" }
    end
  end

  # POLYMORPHIC ASSOCIATION
  describe "noteable association" do
    before do
      @account = FactoryGirl.create :account
      @account.add_member user
    end
    describe "a noteable model" do
      #because it;s without the it clause, it will run everytime. 
      #with the it clause it will cause issue because there is a nested describe inside
      #which will cause it to have an error
      # test_notes do
      #   let(:model) { @account } 
      # end
      it "works with notes as js"
    end
  end
end

describe "account security management" do
  before do
    @account = FactoryGirl.create :account
    visit account_security_path @account
  end

  it "should not do anything...delete!"
end


private

def create_account_and_roles
  #owner account
  @owner_account = FactoryGirl.create :account, name: "Owner Account"
  @owner_account.add_owner user

  #not being owner
  other_user = FactoryGirl.create :user
  @user_member_account = FactoryGirl.create :account, name: "User member account"

  #add users to account roles
  @user_member_account.add_owner other_user
  @user_member_account.add_member user

  #other_user account only
  @other_user_account = FactoryGirl.create :account, name: "Other user account"
  @other_user_account.add_owner other_user
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
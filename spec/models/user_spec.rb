require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build :user
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:accounts) } 

  it { should be_valid }

  it { should have_many(:accounts) } 
  it { should have_many(:account_roles) } 

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "account relationship" do

    it "lists all the accounts the user owns" do
      @user.save
      account1 = FactoryGirl.create(:account)
      account2 = FactoryGirl.create(:account)
      account3 = FactoryGirl.create(:account)

      @user.account_roles.create(account: account1, role: "owner")
      @user.account_roles.create(account: account2, role: "member")
      @user.account_roles.create(account: account3, role: "viewer")

      expect(@user.owned_accounts).to include account1
      expect(@user.member_accounts).to include account2
      expect(@user.can_modify? account1).to be true
      expect(@user.can_modify? account2).to be true
      expect(@user.can_modify? account3).to be false

    end
  end
end
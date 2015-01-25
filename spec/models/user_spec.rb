require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build :user
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

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
end
require 'spec_helper'

describe Account do
  before do
    @account = FactoryGirl.create :account
  end
  subject {@account}

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should be_valid }
  it { should respond_to(:payments) } 

  describe "without a name" do
    before {@account.name = "" }
    it { should_not be_valid}
  end

  describe "adding payment to account" do
    before { @payment = account.payments.create(:payment_date: Date.today) }
    its(:payments) { count }
  end
end

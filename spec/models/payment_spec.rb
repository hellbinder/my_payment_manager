require 'spec_helper'
require 'rspec/its'

describe Payment do
  let(:account) { FactoryGirl.create :account }
  before { @payment = account.payments.create(payment_date: Date.today) }

  subject { @payment }

  it { should respond_to(:account_id) } 
  it { should respond_to(:payment_date) } 
  it { should respond_to(:is_recurring) }

  its(:account) { should eq account } 

  describe "account id is nil" do
    before { @payment.account_id = nil }
    it {should_not be_valid}
  end
end

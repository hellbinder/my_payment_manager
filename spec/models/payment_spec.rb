require 'spec_helper'
require 'rspec/its'

describe Payment do
  let(:account) { FactoryGirl.create :account }
  before { @payment = account.payments.create(payment_date: Date.today) }

  subject { @payment }

  it { is_expected.to respond_to(:account_id) } 
  it { is_expected.to respond_to(:payment_date) } 
  it { is_expected.to respond_to(:amount) } 
  it { is_expected.to belong_to(:account) }
  its(:account) { should eq account } 

  describe "account id is nil" do
    before { @payment.account_id = nil }
    it { is_expected.not_to be_valid}
  end
end

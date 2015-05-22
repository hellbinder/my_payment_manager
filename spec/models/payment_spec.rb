require 'spec_helper'
require 'rspec/its'

describe Payment do
  let(:account) { FactoryGirl.create :account }
  before { @payment = account.payments.create(payment_date: Date.today, amount: 100) }

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
  describe "payment_date field" do
    before { @payment.payment_date = Date.parse("01/01/2005") }
    it { is_expected.to be_valid }
  end
  describe "amount is empty" do
    before { @payment.amount = nil }
    it { is_expected.not_to be_valid }
  end
  describe "amount is < 0" do
    before { @payment.amount = 0 }
    puts @paymennt
    it { is_expected.not_to be_valid }
  end
  it { should belong_to(:account) }

  describe "payment_sum_for_user" do
    before { @user = FactoryGirl.create :user }
    it "should sum up the payments correctly" do
      expect { Payment.payment_sum_for_user(@user).to eq 3 }
    end
  end
end

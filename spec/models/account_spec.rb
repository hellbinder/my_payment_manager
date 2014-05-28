require 'spec_helper'
# require "/home/hellbinder/dev/rails/my_payment_manager/spec/support/models_spec_helper"
#   def responds_to(props)
#     props.each do |s|
#       it { is_expected.to respond_to(s) }
#     end
  # end

describe Account do
  before do
    @account = FactoryGirl.create :account
  end
  subject { @account }
  
  context "with valid information" do
    it { is_expected.to be_valid }
  end

  context "without a name" do
    before {@account.name = "" }
    it { should_not be_valid }
  end
  
#relations
  describe "payments relation" do
    before { @payment = @account.payments.create(payment_date: Date.today) }
    it "adds a payment to the account" do
      expect(@account).to have(1).payments
    end
    
  end
end

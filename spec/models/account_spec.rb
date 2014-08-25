require 'spec_helper'
# require "/home/hellbinder/dev/rails/my_payment_manager/spec/support/models_spec_helper"
#   def responds_to(props)
#     props.each do |s|
#       it { is_expected.to respond_to(s) }
#     end
  # end

describe Account do 
  before { @account = FactoryGirl.create :account}
  it "is invalid with a blank account name" do
    expect(FactoryGirl.build :account, name: "").to_not be_valid
  end
  
  it "checks for valid url" do
    expect(FactoryGirl.build :account, homepage: "http://www.citi.com").to be_valid
  end
  it "is invalid with wrongly typed urls" do |variable|
    expect(FactoryGirl.build :account, homepage: "wwwsfa.froo34d.vime").to_not be_valid
    expect(FactoryGirl.build :account, homepage: "wwwsfa.froo...34d.vime").to_not be_valid
    expect(FactoryGirl.build :account, homepage: "wwwsfa).to_not be_valid").to_not be_valid
  end

#relations
  describe "payments relation" do
    before { @account.payments.create(payment_date: Date.today) }
    it "adds a payment to the account" do
      expect(@account).to have(1).payments
    end
  end
end

require 'spec_helper'

describe CreditCard do
  it "is valid with name, credit limit, interest rate" do
    expect(FactoryGirl.build :credit_card).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build :credit_card, name: nil).to_not be_valid
  end
  it "is invalid without a credit limit" do
    expect(FactoryGirl.build :credit_card, credit_limit: nil).to_not be_valid
  end
  it "is invalid without an interest rate" do
    expect(FactoryGirl.build :credit_card, interest_rate: nil).to_not be_valid
  end
  it "checks for valid url" do
    expect(FactoryGirl.build :credit_card, homepage: "http://www.citi.com").to be_valid
  end
  it "is invalid with wrongly typed urls" do |variable|
    expect(FactoryGirl.build :credit_card, homepage: "wwwsfa.froo34d.vime").to_not be_valid
    expect(FactoryGirl.build :credit_card, homepage: "wwwsfa.froo...34d.vime").to_not be_valid
    expect(FactoryGirl.build :credit_card, homepage: "wwwsfa).to_not be_valid").to_not be_valid
  end

  #associations
    it { is_expected.to have_many(:notes).dependent(:destroy) }
  end

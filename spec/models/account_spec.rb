require 'spec_helper'
# require "/home/hellbinder/dev/rails/my_payment_manager/spec/support/models_spec_helper"
#   def responds_to(props)
#     props.each do |s|
#       it { is_expected.to respond_to(s) }
#     end
  # end

describe Account do 
  before { @account = FactoryGirl.create :account }
  it "is invalid with a blank account name" do
    expect(FactoryGirl.build :account, name: "").to_not be_valid
  end
  
  it "checks for valid url" do
    expect(FactoryGirl.build :account, homepage: "http://www.citi.com").to be_valid
  end
  it "is invalid with wrongly typed urls" do
    expect(FactoryGirl.build :account, homepage: "wwwsfa.froo34d.vime").to_not be_valid
    expect(FactoryGirl.build :account, homepage: "www.froo...34d.vime").to_not be_valid
    expect(FactoryGirl.build :account, homepage: "wwwsfa).to_not be_valid").to_not be_valid
  end

  #relations
  it { is_expected.to have_many(:payments).dependent(:destroy) }
  it { is_expected.to have_many(:users)}
  it { is_expected.to have_many(:user_roles).dependent(:destroy) } 

  #custom methods
  it { is_expected.to respond_to :members }
  it { is_expected.to respond_to :viewers }
  it { is_expected.to respond_to :owner }

  #custom authorization methods
  describe "retrieval of owner when creating account" do 
    let(:user_owner) { FactoryGirl.create :user, name: "user_owner" }
    before { @account.user_roles.create(user: user_owner, role: "owner") }
    it { expect(@account.owner.name).to eq "user_owner" }
  end

  describe "result count from custom methods" do
    before do
      5.times do
        @account.user_roles.create(user: FactoryGirl.create(:user), role: "member")
      end
      3.times do
        @account.user_roles.create(user: FactoryGirl.create(:user), role: "viewer")
      end
    end
      
      it { expect(@account.members.count).to eq 5 }
      it { expect(@account.viewers.count).to eq 3 }
  end
  
  describe "payments relation" do
    before { @account.payments.create(payment_date: Date.today, amount: 10, paid: false) }
    it "has a payement for the account" do
      expect(@account.payments.count).to eq(1)
    end
  end

  #total amountx paid scope
  describe "amount paid methods" do
    before do
      new_time = Time.local(2015, 1, 13, 12, 0, 0)
      Timecop.freeze(new_time)
      create_payments
    end
    after do
      Timecop.return
    end
    it { expect(@account.total_payment_amount).to eq 200 }
    it { expect(@account.total_payment_amount_by_month).to eq 150 }

    context "unpaid payment" do
      before { @account.payments.create(payment_date: 1.day.ago, amount: 20, paid: false) }
      it { expect(@account.total_payment_amount_by_month).to eq 150 }
    end
  end

private
  def create_payments
    @account.payments.create(payment_date: 1.day.ago, amount: 20, paid: true)
    @account.payments.create(payment_date: 2.days.ago, amount: 30, paid: true)
    @account.payments.create(payment_date: 3.days.ago, amount: 50, paid: true)
    @account.payments.create(payment_date: 2.days.ago, amount: 50, paid: true)
    @account.payments.create(payment_date: 1.month.ago, amount: 50, paid: true)
  end
end

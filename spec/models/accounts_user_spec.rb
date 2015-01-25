require 'spec_helper'

describe AccountsUser do
  #fields
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:account_id) }
  it { should validate_presence_of(:role) }

  #relations
  it { should belong_to(:account) }
  it { should belong_to(:user) } 

  # before { FactoryGirl.create :accounts_users}
end

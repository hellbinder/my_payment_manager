class AccountsUser < ActiveRecord::Base
  validates_presence_of :account_id
  validates_presence_of :user_id
  validates_presence_of :role

  belongs_to :account
  belongs_to :user
end

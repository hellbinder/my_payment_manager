class AccountsUser < ActiveRecord::Base
  ROLES = ["owner", "member", "viewer"]

  validates_presence_of :account_id
  validates_presence_of :user_id
  validates_presence_of :role
  validates :user_id, uniqueness: {scope: :account_id, message: "already exists for the current account"}

  belongs_to :account
  belongs_to :user

  private
end

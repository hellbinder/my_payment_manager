class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name
  has_many :account_roles, foreign_key: "user_id", class_name: "AccountsUser"
  has_many :accounts, through: :account_roles

  def can_modify?(account)
    account.user_roles.where(user: self, role: ["owner", "member"]).exists?
  end

  def owned_accounts
    accounts.where("accounts_users.role = ?", "owner")
  end

  def member_accounts
    accounts.where("accounts_users.role = ?", "member")
  end

end


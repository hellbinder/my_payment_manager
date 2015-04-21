class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name
  has_many :account_roles, foreign_key: "user_id", class_name: "AccountsUser"
  has_many :accounts, through: :account_roles

  def can_view?(account)
    account.user_roles.where(role: ["owner", "member", "viewer"], user: self).exists?
  end

  def can_modify?(account)
    account.user_roles.where(role: ["owner", "member"], user: self).exists?
  end

  def can_delete?(account)
    account.user_roles.where(user: self, role: ["owner"]).exists?
  end

  def editable_accounts
    user_accounts_with_role ["owner","member"]
  end

  def owned_accounts
    user_accounts_with_role "owner"
  end

  def member_accounts
    user_accounts_with_role "member"
  end

  private

  def user_accounts_with_role(roles)
    #TALK ABOUT THIS IN A BLOG!. filter by intermediate tables!
    # accounts_users.joins(accounts).where("accounts_users.role = ?", "#{role}")
    accounts.where(accounts_users: { role: roles})
  end

end


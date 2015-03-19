class Account < ActiveRecord::Base
  validates_presence_of :name
  validates :homepage, url: true
  has_many :payments, dependent: :destroy
  has_many :user_roles, dependent: :destroy, foreign_key: "account_id", class_name: "AccountsUser" #alias table
  has_many :users, through: :user_roles #have to use the alias name for this to work.

  #custom filters
  def owner
    #user_roles.where(role: "owner").first.user
    find_user_by_role("owner").first
  end

  def members
    find_user_by_role("member")
  end

  def viewers
    find_user_by_role("viewer")
  end

  def all_users_roles
    user_roles
    .joins(:user)
    .select('accounts.id, accounts.name, users.name as user_name, accounts_users.role as role')
  end

  def total_payment_amount
   payments.sum(:amount)
  end

  def add_owner(user)
    user_roles.create(user: user, role: "owner")
  end
  
  private

  def find_user_by_role(role)
    users.where("accounts_users.role = ?", role)
  end

end
class Account < ActiveRecord::Base
  validates_presence_of :name
  validates :homepage, url: true
  has_many :payments, dependent: :destroy
  has_many :user_roles, foreign_key: "account_id", class_name: "AccountsUser" #alias table
  has_many :users, through: :user_roles #have to use the alias name for this to work.

  #custom filters
  def owner
    user_roles.where("role = 'owner'")
  end

  def moderators
    user_roles.where("role = 'moderator'")
  end

  def viewers
    user_roles.where("role= 'viewers'")
  end

  def total_payment_amount
   payments.sum(:amount)
  end

end
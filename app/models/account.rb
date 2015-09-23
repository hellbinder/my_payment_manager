class Account < ActiveRecord::Base
  include IceCube

  

  serialize :schedule, Hash

  validates_presence_of :name
  validates :homepage, url: true
  has_many :payments, dependent: :destroy
  has_many :user_roles, dependent: :destroy, foreign_key: "account_id", class_name: "AccountsUser" #alias table
  has_many :users, through: :user_roles #have to use the alias name for this to work.
  has_many :notes, as: :noteable
  
  #custom filters
  def owner
    #user_roles.where(role: "owner").first.user
    find_user_by_role("owner").first.user
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

  def total_payment_amount_by_month
    payments
    .where('extract(month from payment_date) = ? and extract(year from payment_date) = ?', Date.today.month, Date.today.year)
    .where(paid: true)
    .sum(:amount)
  end
  
  def add_owner(user)
    add_user_to_role(user, "owner")
  end

  def add_member(user)
    add_user_to_role(user, "member")
  end

  def add_viewer(user)
    add_user_to_role(user, "viewer")
  end

  #Schedule override so it's saved normally but retrieved as a recurring schedule
  #Below method will override the proprerty so it will store the rule as a hash instead of string.
  
  #https://github.com/GetJobber/recurring_select/issues/6 
  #helped me fix the issue where it was storing rules as a string and needed it as a hash (can also be done in yaml if so desired)
  def schedule=(new_rule)
    if RecurringSelect.is_valid_rule?(new_rule)
      write_attribute(:schedule, RecurringSelect.dirty_hash_to_rule(new_rule).to_hash)
    else
      write_attribute(:schedule, nil)
    end
  end

  #returns the schedule with the recurrent rule saved. This can then be used to query the database for recurring schedules and create background jobs if needed (or anything you can think of)
  def converted_schedule
    if !self.read_attribute(:schedule).empty?
        the_schedule = IceCube::Schedule.new( self.created_at )
        the_rule = RecurringSelect.dirty_hash_to_rule( self.read_attribute(:schedule) )
     if RecurringSelect.is_valid_rule?(the_rule)
        the_schedule.add_recurrence_rule(the_rule)
     end
     the_schedule
    end
  end

  def paid_payments
    payments.where( paid: true )
  end

  def next_payment_date
    converted_schedule.next_occurrence.to_date.strftime('%m/%d/%Y')
  end

  private

  def find_user_by_role(role)
    user_roles.includes(:user).references(:user).where("role = ?", role)
  end

  def add_user_to_role(user, role)
    user_roles.create(user: user, role: role)
  end
end
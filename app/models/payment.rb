class Payment < ActiveRecord::Base
  # attr_accessor :account_id, :payment_date, :is_recurring <- NOT workign with facotyr girl when turned on
  validates_presence_of :account_id, message: "must be selected"
  validates :amount, format:{ with: /\A\d+(?:\.\d{0,2})?\z/, message: "should be in the ###,###.00 format" },
   numericality: { greater_than: 0 },
   presence: { message: "is required"}

  belongs_to :account
  #Validate date and number format here.
  validate do
      self.errors[:payment_date] << "must be a valid date" unless DateTime.parse(self.payment_date) rescue false
   end

   def self.payment_sum_for_user(user)
    where(account_id: user.accounts)
    .group_by_year(:payment_date)
    .sum(:amount)
    # .where('extract(year from payment_date) = ?', Time.now.year)

   end
end

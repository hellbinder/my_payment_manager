class Payment < ActiveRecord::Base
  # attr_accessor :account_id, :payment_date, :is_recurring <- NOT workign with facotyr girl when turned on
  validates_presence_of :account_id, message: "An account must be associated with this payment"
  validates_presence_of :amount, message: "The amount field is required"
  validates :amount, numericality: { greater_than: 0 }
  belongs_to :account
  #Validate date and number format here.
  validate do
      self.errors[:payment_date] << "must be a valid date" unless DateTime.parse(self.payment_date) rescue false
   end
end

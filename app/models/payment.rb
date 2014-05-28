class Payment < ActiveRecord::Base
  # attr_accessor :account_id, :payment_date, :is_recurring <- NOT workign with facotyr girl when turned on
  validates_presence_of :account_id, message: "An account must be associated with this payment"
  belongs_to :account
end

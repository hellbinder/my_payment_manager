class CreditCard < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :interest_rate
  validates_presence_of :credit_limit
  validates :homepage, url: true
  has_many :notes, as: :noteable, dependent: :destroy
end

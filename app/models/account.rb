class Account < ActiveRecord::Base
  validates_presence_of :name
  validates :homepage, url: true
  has_many :payments, dependent: :destroy

  def total_payment_amount
   payments.sum(:amount)
  end

end
class Account < ActiveRecord::Base
  validates_presence_of :name
  validates :homepage, url: true
  has_many :payments, dependent: :destroy
end

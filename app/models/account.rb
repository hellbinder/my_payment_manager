class Account < ActiveRecord::Base
  attr_accessor :name, :description
  validates_presence_of :name
  has_many :payments, dependent: :destroy
end

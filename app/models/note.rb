class Note < ActiveRecord::Base
  validates_presence_of :title, :detail
  belongs_to :noteable
end

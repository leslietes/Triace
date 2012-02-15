class Subdepartment < ActiveRecord::Base
  belongs_to :department
  has_many   :transactions
  
  validates_presence_of :name
end

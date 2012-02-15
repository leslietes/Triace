class Department < ActiveRecord::Base
  has_many :subdepartments
  has_many :transactions
  
  validates_presence_of :name
end

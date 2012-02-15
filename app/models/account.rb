class Account < ActiveRecord::Base
  
  has_many :transactions

  validates :name, :length   => { :maximum => 100 },
                   :presence => true
  
  validates :_type, :length   => { :maximum => 100 },
                   :presence => true
  
end

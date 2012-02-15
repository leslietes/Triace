class Payee < ActiveRecord::Base
  
  has_many :transactions
  
  validates :name,      :presence   => true,
                        :uniqueness => true,
                        :length     => { :within => 3..40 }

  validates :other_name, :uniqueness => true,
                         :length     => { :maximum => 100 },
                         :allow_nil  => true
                         
  validates :telnum,     :length    => {:maximum => 50 },
                         :allow_nil => true
                     
  validates :contact,    :length    => {:maximum => 100 },
                         :allow_nil => true
                     
end

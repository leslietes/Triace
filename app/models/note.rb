class Note < ActiveRecord::Base
belongs_to :product

def closed
self.close = true
self.close_date = Date.today
self.save
end
end

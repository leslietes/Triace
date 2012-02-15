class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  
  protected
  
  def login_required
    if !current_user
      redirect_to root_url
    else
      return true
    end
  end

 def get_products
    @products = Product.select("id, name").order("name ASC")
  end

  def get_customers
    @customers = Customer.select("id, name").order("name ASC")
  end
end

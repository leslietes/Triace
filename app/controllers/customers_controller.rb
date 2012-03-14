class CustomersController < ApplicationController
  before_filter :login_required
  def index
    @customers = Customer.find(:all, :order => "name ASC")
  end
  
  def show
    @customer = Customer.find_by_id(params[:id])
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(params[:customer])
    if @customer.save
      redirect_to customer_url(@customer), :notice => "Customer added successfully."
    else
      render :action => 'new', :status => :unprocessable_entity
    end
  end

  def edit
    @customer = Customer.find_by_id(params[:id])
  end
  
  def update
    @customer = Customer.find_by_id(params[:id])
    if @customer.update_attributes(params[:customer])
      redirect_to customers_url, :notice => "Customer successfully updated." 
    else
      render :action => 'edit'      
    end
  end
end

class ProductsController < ApplicationController
before_filter :login_required
   def index
    @products = Product.find(:all, :order => "name ASC")
  end
  
  def show
    @product = Product.find_by_id(params[:id])
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to product_url(@product), :notice => "Product added successfully."
    else
      render :action => 'new', :status => :unprocessable_entity
    end
  end

  def edit
    @product = Product.find_by_id(params[:id])
  end
  
  def update
    @product = Product.find_by_id(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to products_url, :notice => "Product successfully updated." 
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @product = Product.find_by_id(params[:id])
    if @product.destroy
      flash[:notice] = "Successfully deleted product"
    else
      flash[:error] = "Error in deleting product"
    end
    redirect_to products_url
  end

  def get_price
    product = Product.find_by_id(params[:id])
    if product
      @price = product.distributors_price
      @balance = product.balance
    end
  end

  def get_qty
    product = Product.find_by_id(params[:id])
    if product
      @qty = product.balance
      render :none
      return
    end
    return
  end
end

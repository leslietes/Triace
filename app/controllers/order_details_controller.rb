class OrderDetailsController < ApplicationController
  before_filter :get_products
  def create
    order = Order.find_by_id(params[:order_id])
    if order
      @detail = order.order_details.create(
		:quantity   => params[:quantity],
	        :unit	=> params[:unit],
 		    :product_id => params[:product_id],
 		    :unit_price => params[:distributors_price] )
      if @detail.save
        redirect_to order_url(order), :notice => "Order successfully added."
      else
        render order_url, :status => :unprocessable_entity
      end
    end
  end

  def edit
    @order = Order.find_by_id(params[:order_id])
    if @order
      @order_detail = @order.order_details.find_by_id(params[:id])
    else
      redirect_to order_url(@order)
    end
  end

  def update
    order = Order.find_by_id(params[:order_id])
    if order
      @order_detail = order.order_details.find_by_id(params[:id])
      if @order_detail.update_attributes(params[:order_detail])
        flash[:notice] = "Delivery detail successfully updated."
        redirect_to order_url(order)
      else
        flash[:error] = "Unable to update delivery detail."
        render :action => 'edit'
      end
    else
      redirect_to order_url(order)
    end
  end

  def destroy
    order = Order.find_by_id(params[:order_id])
    if order
      detail = order.order_details.find_by_id(params[:id])
      if detail.destroy
        flash[:notice] = "Order detail deleted."
      else
        flash[:error] = "Unable to remove order detail."
      end
    end
    redirect_to order
  end
end

class PoDetailsController < ApplicationController

  before_filter :get_products

  def create
    po = Po.find_by_id(params[:po_id])
    if po
      @detail = po.po_details.create(
		    :quantity   => params[:quantity],
 		    :unit	=> params[:unit],
 		    :product_id => params[:product_id],
 		    :case_price => params[:case_price])
      if @detail.save
        redirect_to po_url(po), :notice => "PO successfully added."
      else
        render po_url, :status => :unprocessable_entity
      end
    end
  end
 
  def edit
    @po = Po.find_by_id(params[:po_id])
    if @po
      @po_detail = @po.po_details.find_by_id(params[:id])
    else
      redirect_to po_url(@po)
    end
  end

  def update
    @po = Po.find_by_id(params[:po_id])
    if @po
      @po_detail = @po.po_details.find_by_id(params[:id])
      if @po_detail.update_attributes(params[:po_detail])
        flash[:notice] = "PO detail successfully updated."
        redirect_to po_url(@po)
      else
        flash[:error] = "Unable to update po detail."
        render :action => 'edit'
      end
    else
      redirect_to po_url(@po)
    end
  end

end

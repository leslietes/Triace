class PosController < ApplicationController
  before_filter :login_required
  before_filter :get_products
def index
  @pos = Po.all
end

def show  
  @po = Po.find_by_id(params[:id])
  if @po
     @details = PoDetail.find(:all, :conditions => ["po_id = ?", @po.id], :include => [:product], :order => "products.name ASC")
     @new_detail = @po.po_details.new
  end
  respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "show.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "PO No #{@po.id} - #{@po.po_date}.pdf", :type => 'application/pdf')
        return
      }
    end
end

def new
  @po = Po.new
end

def create
@po = Po.new(params[:po])
    if @po.save
      redirect_to po_url(@po), :notice => "PO added successfully."
    else
      render :action => 'new', :status => :unprocessable_entity
    end
end

def edit
  @po = Po.find_by_id(params[:id])
end

def update
 @po = Po.find_by_id(params[:id])
    if @po.update_attributes(params[:po])
      redirect_to pos_url, :notice => "PO successfully updated." 
    else
      render :action => 'edit'
    end
end

def destroy
@po = Po.find_by_id(params[:id])
    if @po.destroy
      flash[:notice] = "Successfully deleted PO"
    else
      flash[:error] = "Error in deleting PO"
    end
    redirect_to pos_url
end
end

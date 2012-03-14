class InventoriesController < ApplicationController
  before_filter :login_required
  before_filter :get_products
  before_filter :get_customers, :only => [:order_by_customer]
  def index
    @inventories = Product.find(:all, :order => "name ASC", :conditions => ["product_code != ?", "SINCLAIR"])
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "index.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Inventory as of #{Date.today}.pdf", :type => 'application/pdf')
        return
      }
    end
  end

  def paints
    @inventories = Product.find(:all, :conditions => ["product_code = ?", "SINCLAIR"], :order => "name ASC")
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "index.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Inventory as of #{Date.today}.pdf", :type => 'application/pdf')
        return
      }
    end
  end

  def order_list
    @inventories = Product.find(:all, :conditions => ["balance = 0"], :order => "name ASC")
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "index.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Order List as of #{Date.today}.pdf", :type => 'application/pdf')
        return
      }
    end
  end

  
  def show
    @product     = Product.find(:first, :select => ["name"], :conditions => ["id = ?",params[:id]])
    #@inventories = Inventory.find(:all, :conditions => ["product_id = ? and closed = false", params[:id]], :order => "id DESC")
    @inventories = Inventory.find(:all, :conditions => ["product_id = ?", params[:id]], :order => "id DESC")
  end
  
  def edit
    @inventories = Inventory.find_by_id(params[:id])
  end

  def update
    @inventories = Inventory.find_by_id(params[:id])
    product = @inventories.product_id
    if @inventories.update_attributes(params[:inventory])
      #redirect_to inventories_url, :notice => "Inventory successfully updated."
      redirect_to recalculate_inventory_url(product) 
    else
      render :action => 'edit'
    end
  end

  def destroy
    inventory = Inventory.find_by_id(params[:id])
    product   = inventory.product_id
    if inventory
      if inventory.destroy
        flash[:notice] = "Inventory entry deleted."
      else
        flash[:error] = "Unable to remove inventory entry."
      end
    end
    redirect_to recalculate_inventory_url(product)
  end

  #todo: use class method in Product
  def recalculate
    product = Product.find_by_id(params[:id])
    @inventories = product.inventories
    if @inventories.empty?
      product.update_balance(0)
      redirect_to inventories_url 
      flash[:notice] = "No entries found."
      return 
    end

    count = 0
    @inventories.each do |i|
      count = count + i.item_in - i.item_out
    end
    
    if product.balance != count
      product.update_balance(count)
    end

    flash[:notice] = "#{count} #{product.name} left."
    redirect_to inventories_url
  end

  def close
    inventories = Inventory.find(:all, :conditions => ["closed = false"])
    inventories.each do |i|
      i.close
    end
    flash[:notice] = "Inventory closed"
    redirect_to inventories_url
  end

  def order_summary

 if params[:format] == 'pdf'
      @date_from    = session[:date_from]
      @date_to      = session[:date_to]
      @include_summary = session[:summary]
    else
      @date_from    = params[:date_from] || Time.now.beginning_of_month.to_date
      @date_to      = params[:date_to]   || Time.now.end_of_month.to_date
      @include_summary = params[:summary] || "0"

      session[:date_from]   = @date_from
      session[:date_to]     = @date_to
      session[:summary]     = @include_summary
    end

    @orders = []
    sql = []

    #sql = "Select products.name, products.distributors_price, sum(inventories.item_out) as quantity, products.count_per_pack from products left join inventories on products.id = inventories.product_id"

    #sql = "Select products.name, products.distributors_price, sum(inventories.item_out) as quantity, products.count_per_pack from products, inventories where products.id = inventories.product_id "

    #sql = "Select orders.id, customers.name, orders.total_amount, orders.order_date from orders, customers where orders.customer_id = customers.id"


    if !session[:date_from].nil?
      sql << " DATE(orders.order_date) >= DATE('#{@date_from}') "
    end

    if !session[:date_to].nil?
      sql << " DATE(orders.order_date) <= DATE('#{@date_to}') "
    end

    sql = sql.join(' and ')

    @orders = Order.find(:all, :conditions => [sql], :include => [:customer, {:order_details => :product}], :order => "customers.name ASC, products.name ASC")

    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "order_summary.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Order Summary as of #{Date.today}.pdf", :type => 'application/pdf')
        return
      }
    end
  end

  def order_by_customer
    @orders = []

    if params[:format] == 'pdf'
      @date_from    = session[:date_from]
      @date_to      = session[:date_to]
      @customer_id  = session[:customer_id]
      @include_summary = session[:summary]
    else
      @date_from    = params[:date_from] || Time.now.beginning_of_month.to_date
      @date_to      = params[:date_to]   || Time.now.end_of_month.to_date
      @customer_id  = params[:customer_id]
      @include_summary = params[:summary] || "0"

      session[:date_from]   = @date_from
      session[:date_to]     = @date_to
      session[:customer_id] = @customer_id
      session[:summary]     = @include_summary
    end
 
    sql = []

    if !session[:customer_id].blank?
      sql << [" orders.customer_id = #{@customer_id} "]
    end

    if !session[:date_from].nil?
      sql << [" DATE(orders.delivered_date) >= DATE('#{@date_from}') "]
    end

    if !session[:date_to].nil?
      sql << [" DATE(orders.delivered_date) <= DATE('#{@date_to}') "]
    end

    sql = sql.join(" and ")

    @orders = Order.find(:all, :include => [{:order_details => :product}, :customer], 
                         :conditions => [sql])

     respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "order_by_customer.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Orders By Customer from #{@date_from} to #{@date_to}.pdf", :type => 'application/pdf')
        return
      }
    end
  end

  def order_by_product
    
    if params[:format] == 'pdf'
      @date_from= session[:date_from]
      @date_to  = session[:date_to]
      @product  = session[:product]
      @include_summary = session[:summary]
    else
      @date_from = params[:date_from] || Time.now.beginning_of_month.to_date
      @date_to   = params[:date_to]   || Time.now.end_of_month.to_date
      @product   = params[:product]
      @include_summary = params[:summary] || "0"

      session[:date_from] = @date_from
      session[:date_to]   = @date_to
      session[:product]   = @product
      session[:summary]   = @include_summary
    end
 
    sql   = []
    group = ""

    #sql = "select products.name, sum(order_details.quantity) as quantity, order_details.unit as unit, order_details.unit_price as unit_price, products.count_per_pack as count from orders, order_details, products where orders.id = order_details.order_id and order_details.product_id = products.id "
 
    if !session[:product].blank?
       sql << [" order_details.product_id = #{@product} "]
    end

    if !session[:date_from].nil?
      sql << [" DATE(orders.order_date) >= DATE('#{@date_from}') "]
    end

    if !session[:date_to].nil?
      sql << [" DATE(orders.order_date) <= DATE('#{@date_to}') "]
    end

    sql << [" products.product_code != 'SINCLAIR' "]

    sql = sql.join(" and ")
    
    #select distinct orders.order_date, orders.id, order_details.product_id, products.name from orders, order_details, products where orders.id = order_details.order_id and order_details.product_id = products.id and DATE(orders.order_date) >= '2012-03-01' and DATE(orders.order_date) <= '2012-03-31' order by products.id ASC, orders.order_date ASC, orders.id ASC;
puts "=========================#{sql}"
puts "=======================#{@include_summary.class}"
    #todo add customer association
    #if !session[:summary] == "1"
    if @include_summary == "1"
puts "here here here"
    @products = Product.find(:all, :include => [{:order_details => :order} ], 
                               :conditions => [sql], :order => "products.name ASC, orders.order_date ASC") #, :group => "products.id")

    else
# unclicked
puts "there there there"
# @products = Product.find(:all, :include => [{:order_details => :order}], :select => " distinct order_details.product_id, products.name, sum(order_details.quantity) as #quantity ", :conditions => [sql], :order => "products.name ASC", :group => "order_details.product_id")
    @products = OrderDetail.find_by_sql("select distinct order_details.product_id, 
					  products.name,
					  products.count_per_pack,
					  sum(order_details.quantity) as quantity
				   from orders, order_details, products 
				   where orders.id = order_details.order_id and 
					 order_details.product_id = products.id and 
					 #{sql}
				   group by order_details.product_id
				   order by products.name ASC, orders.order_date ASC, orders.id ASC;")


    end
puts "===============#{@products.inspect}"
     respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "/inventories/order_by_product.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Orders By Product as of #{Date.today}.pdf", :type => 'application/pdf')
        return
      }
    end
  end

  def order_levels
          sql = "select products.id, 
			products.name, 
			products.balance,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-01-01' and
			      DATE(orders.order_date) <= '2012-01-31') as january,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-02-01' and
			      DATE(orders.order_date) <= '2012-02-31') as february,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-03-01' and
			      DATE(orders.order_date) <= '2012-03-31') as march,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-04-01' and
			      DATE(orders.order_date) <= '2012-04-31') as april,
 			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-05-01' and
			      DATE(orders.order_date) <= '2012-05-31') as may,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-06-01' and
			      DATE(orders.order_date) <= '2012-06-31') as june,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-07-01' and
			      DATE(orders.order_date) <= '2012-07-31') as july,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-08-01' and
			      DATE(orders.order_date) <= '2012-08-31') as august,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-09-01' and
			      DATE(orders.order_date) <= '2012-09-31') as september,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-10-01' and
			      DATE(orders.order_date) <= '2012-10-31') as october,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-11-01' and
			      DATE(orders.order_date) <= '2012-11-31') as november,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-12-01' and
			      DATE(orders.order_date) <= '2012-12-31') as december
	   from products 
	   where products.product_code != 'SINCLAIR' 
	   group by products.id 
	   ORDER BY products.name asc, products.id"
   @orders = Product.find_by_sql(sql)
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "order_levels.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Order Level 2012.pdf", :type => 'application/pdf')
        return
      }
    end

  end

  def order_level_paints
          sql = "select products.id, 
			products.name, 
			products.balance,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-01-01' and
			      DATE(orders.order_date) <= '2012-01-31') as january,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-02-01' and
			      DATE(orders.order_date) <= '2012-02-31') as february,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-03-01' and
			      DATE(orders.order_date) <= '2012-03-31') as march,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-04-01' and
			      DATE(orders.order_date) <= '2012-04-31') as april,
 			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-05-01' and
			      DATE(orders.order_date) <= '2012-05-31') as may,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-06-01' and
			      DATE(orders.order_date) <= '2012-06-31') as june,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-07-01' and
			      DATE(orders.order_date) <= '2012-07-31') as july,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-08-01' and
			      DATE(orders.order_date) <= '2012-08-31') as august,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-09-01' and
			      DATE(orders.order_date) <= '2012-09-31') as september,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-10-01' and
			      DATE(orders.order_date) <= '2012-10-31') as october,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-11-01' and
			      DATE(orders.order_date) <= '2012-11-31') as november,
			(select sum(order_details.quantity) 
			from order_details, orders 
			where order_details.order_id = orders.id and 
			      products.id = order_details.product_id and 
			      DATE(orders.order_date) >= '2012-12-01' and
			      DATE(orders.order_date) <= '2012-12-31') as december
	   from products 
	   where products.product_code = 'SINCLAIR' 
	   group by products.id 
	   ORDER BY products.name asc, products.id"
   @orders = Product.find_by_sql(sql)
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "order_level_paints.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Order Level 2012.pdf", :type => 'application/pdf')
        return
      }
    end

  end


end

class SalesController < ApplicationController

  def index
    # @sales_near_by = Sale.where('longitude is NOT NULL')
    
    latitude = params[:latitude] || 43.653226
    longitude = params[:longitude] || -79.38318429999998
    proximity = params[:proximity] || 1000
    if params[:start_date].nil?
      @start_date = Time.now - 14.days
    else
      @start_date = Date.parse(params[:start_date])
    end
    if params[:end_date].nil?
      @end_date = Time.now
    else
      @end_date = Date.parse(params[:end_date])
    end 
    @sales_near_by = Sale.find_by_sql ["SELECT *,earth_distance(ll_to_earth(?,?), ll_to_earth(s.latitude, s.longitude)) as distance_from_current_location FROM sales s WHERE earth_box(ll_to_earth(?,?),?) @> ll_to_earth(s.latitude,s.longitude) ORDER BY distance_from_current_location ASC",latitude,longitude,latitude,longitude,proximity]
    @sales_near_by = @sales_near_by.select{|sale| sale.sold_date >= @start_date and sale.sold_date <= @end_date }
    respond_to do |format|
      format.html
      format.js
    end
  end



  def show
  	@sale = Sale.find_by_id(params[:id])
  	if @sale.non_house_id != 0
  		render :json => @sale.to_json(:include => :non_house)
  	else
  		render :json => @sale.to_json(:include => :house)
  	end
  end

end

class SalesController < ApplicationController

  def index
    # @sales_near_by = Sale.where(longitude: nil)
    @sales_near_by = Sale.find_by_sql ["SELECT * FROM sales s WHERE earth_box(ll_to_earth(?,?),?) @> ll_to_earth(s.latitude,s.longitude)",params[:latitude],params[:longitude],1000]    
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

  def proximity_json
    @sales_near_by = Sale.find_by_sql ["SELECT * FROM sales s WHERE earth_box(ll_to_earth(?,?),?) @> ll_to_earth(s.latitude,s.longitude)",params[:latitude],params[:longitude],1000]    
    render :json => @sales_near_by.to_json(:include => [:house,:non_house])
  end


end

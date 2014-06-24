class SalesController < ApplicationController

  def index
  	@sales = Sale.all
	render :json => @sales
  end

  def show
  	@sale = Sale.find_by_id(params[:id])
  	if @sale.house_id != 0
  		render :json => @sale.to_json(:include => :house)
  	else
  		render :json => @sale.to_json(:include => :non_house)
  	end
  end

end

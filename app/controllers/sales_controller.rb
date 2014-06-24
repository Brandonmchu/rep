class SalesController < ApplicationController

  def index
  	@sales = Sale.all
	render :json => @sales
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

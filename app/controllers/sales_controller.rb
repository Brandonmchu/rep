class SalesController < ApplicationController

  def index
  	@sales = Sale.all
	render :json => @sales
  end

  def show
  	@sale = Sale.find_by_id(params[:id])
  	render :json => @sale
  end

end

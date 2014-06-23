class NonHousesController < ApplicationController

  def show
  	@non_house = NonHouse.find_by_id(params[:id])
  	@sales = @non_house.sales
  	render :json => @non_house.to_json(:include => :sales)
  end
  
end

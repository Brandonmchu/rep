class HousesController < ApplicationController

  def show
  	@house = House.find_by_id(params[:id])
  	@sales = @house.sales
  	render :json => @house.to_json(:include => :sales)
  end

end

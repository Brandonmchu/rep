class AddNonHouseIdToSale < ActiveRecord::Migration
  def change
  	add_column :sales, :non_house_id, :integer
  end
end

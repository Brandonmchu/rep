class AddHouseIdToSale < ActiveRecord::Migration
  def change
  	add_column :sales, :house_id, :integer
  end
end

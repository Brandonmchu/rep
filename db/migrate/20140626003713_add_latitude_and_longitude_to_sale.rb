class AddLatitudeAndLongitudeToSale < ActiveRecord::Migration
  def change
    add_column :sales, :latitude, :float
    add_column :sales, :longitude, :float
  end
end

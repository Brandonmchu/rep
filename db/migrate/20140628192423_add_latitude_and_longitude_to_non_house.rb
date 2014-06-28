class AddLatitudeAndLongitudeToNonHouse < ActiveRecord::Migration
  def change
    add_column :non_houses, :latitude, :float
    add_column :non_houses, :longitude, :float
  end
end

class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :address
      t.integer :listprice
      t.integer :soldprice
      t.integer :original_price
      t.string :taxes
      t.string :days_market
      t.string :date_list
      t.string :date_sold
      t.string :unit_type
      t.string :fronting
      t.string :rooms
      t.string :stories
      t.string :acreage
      t.integer :bedrooms
      t.integer :dens
      t.integer :washrooms
	    t.string :lot
      t.string :mls
      t.string :kitchens
      t.string :fam_rm
      t.string :basement
	  t.string :fireplace
	  t.string :sq_foot
	  t.string :mutual
	  t.string :garage_type
	  t.string :parking_spaces
	  t.string :pool
	  t.string :image_urls, array: true, default: '{}'
	  t.string :image_descriptions, array: true, default: '{}'
      t.timestamps
    end
  end
end

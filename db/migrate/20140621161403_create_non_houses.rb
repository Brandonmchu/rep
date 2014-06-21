class CreateNonHouses < ActiveRecord::Migration
  def change
    create_table :non_houses do |t|
    	t.string :address
      	t.string :address_two
	    t.string :unit_type
		t.integer :rooms
		t.integer :plus_rooms
		t.integer :bedrooms
		t.integer :dens
		t.integer :washrooms
		t.string :corp
	    t.string :prop_mgmt
		t.integer :kitchens
		t.string :fam_rm
		t.integer :apx_age
		t.integer :sqft_range_first
		t.integer :sqft_range_second
		t.string :exposure
		t.string :pets
		t.string :locker
		t.integer :level
		t.integer :unit_number
		t.integer :maintenance
		t.string :air_con
		t.string :incl_heat
		t.string :incl_cable
		t.string :incl_insurance
		t.string :incl_comm_elem
		t.string :incl_water
		t.string :incl_hydro
		t.string :incl_cac
		t.string :incl_parking
		t.string :balcony
		t.string :ensuite_laundry
		t.string :laundry_level
		t.string :exterior
		t.string :park_method
		t.string :park_type
		t.integer :park_spaces
		t.integer :park_cost
		t.string :amenities
		t.text :description
      t.timestamps
    end
  end
end

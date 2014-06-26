class Sale < ActiveRecord::Base

	validates :address, :sold_date, :sold_price, :list_price, presence: true
	validates :address, uniqueness: {scope: :sold_date}

	# geocoded_by :address, latitude: :start_latitude, longitude: :start_longitude
	# geocoded_by :address_two, latitude: :end_latitude, longitude: :end_longitude

	# geocoded_by :geo_address
	# after_validation :geocode

	belongs_to :house
	belongs_to :non_house

	# def geo_address
 #  		[:address, :address_two].compact.join(', ')
	# end
end

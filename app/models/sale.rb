class Sale < ActiveRecord::Base

	validates :address, :sold_date, :sold_price, :list_price, presence: true
	validates :address, uniqueness: {scope: :sold_date}

	# geocoded_by :address, latitude: :start_latitude, longitude: :start_longitude
	# geocoded_by :address_two, latitude: :end_latitude, longitude: :end_longitude

	geocoded_by :geoaddress
	after_validation :geocode

	belongs_to :house
	belongs_to :non_house

	def geoaddress
  		postal_code_regex = /(.*)[a-zA-Z]\d[a-zA-Z]\d[a-zA-Z]\d|[a-zA-Z]\d[a-zA-Z]\s\d[a-zA-Z]\d/
		comma_or_space_regex = /([^,\s]*[^,\s])/
		if postal_code_regex.match(address_two).nil?
			
			if comma_or_space_regex.match(address_two).nil?
				shortened_address_two = address_two
			else
				if address_two.scan(comma_or_space_regex).size >=2
					shortened_address_two = [comma_or_space_regex.match(address_two)[0], comma_or_space_regex.match(address_two)[1]].join(", ")
				else
					shortened_address_two = comma_or_space_regex.match(address_two)[0]
				end
			end
		else
			shortened_address_two = postal_code_regex.match(address_two)[0]
		end
		[address, shortened_address_two, "Canada"].compact.join(', ')
	end
end

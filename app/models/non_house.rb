class NonHouse < ActiveRecord::Base

	validates :address, presence: true
	validates :address, uniqueness: true

	has_many :sales

	geocoded_by :geoaddress
	after_validation :geocode, :if => Proc.new{|non_house| non_house.longitude.nil? }

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

def parse_house(listing, address, address_two)

	lot = listing.at_css("tr[2] td tr[4] td[2]").text.strip
	lot_first_dimension = 0
	lot_second_dimension = 0
	lot_dimension_units = "Feet"
	if lot.include? "X"
		lot = lot.split("X")
		lot_first_dimension = lot[0].match(/(\d+)/)[0].to_i
		lot_second_dimension = lot[1].match(/(\d+)/)[0].to_i
		lot_dimension_units = lot[1].match(/(\D\S*)/)[0]
	else
		puts "no lot dimensions: Lot is given as: " + lot
	end
	
	# locate images
	images = listing.at_css("tr td script") 

	# regex for all image links and descriptions
	all_links_regex = /(?<=pixArray = new Array\()[^\)]*/
	parsed_links_regex = /(?<=,|^)'\K[^?]+/
	image_descriptions_regex = /(?<=commArray = new Array\()[^\)]*/
	parsed_descriptions_regex = /[^,]+/
	if all_links_regex.match(images).nil?
			image_urls = []
			image_descriptions = []
	else
			image_urls = all_links_regex.match(images)[0].scan(parsed_links_regex)

			image_urls.each_index do |i|
				image_urls[i] = "http://www.torontomls.net/"+image_urls[i]
			end
			image_descriptions = image_descriptions_regex.match(images)[0].scan(parsed_descriptions_regex)
	end


	#parse bedrooms to split it into bedrooms and dens
	bedrooms_check = listing.at_css("tr[2] td tr[2] td[5]").text.strip
	dens = 0
	bedrooms = 0
	if bedrooms_check.include? "+"
		bedrooms_check = bedrooms_check.split("+")
		bedrooms = bedrooms_check[0].to_i
		dens = bedrooms_check[1].to_i
	elsif bedrooms_check != ""
		bedrooms = bedrooms_check.to_i
	end



	#parse garage into garage type and number of garages
	gargae_type = "Not Available"
	garages = 0
	garage_details = listing.at_css("tr[4] td[2] tr[4] td").text.strip
	if garage_details.include? "/"
		garage_details = garage_details.split("/")
		garage_type = garage_details[0]
		garages = garage_details[1]
	end


	#house hash variables
	unit_type = listing.at_css("tr[2] td tr td").text.strip 
	fronting = listing.at_css("tr[2] td tr td[3]").text.strip 
	
		#parse rooms to split it into rooms and plus_rooms
	rooms_check = listing.at_css("tr[2] td tr td[5]").text.strip
	rooms = 0
	plus_rooms = 0
	if rooms_check.include? "+"
		rooms_check = rooms_check.split("+")
		rooms = rooms_check[0].to_i
		plus_rooms = rooms_check[1].to_i
	elsif rooms_check != ""
		rooms = rooms_check.to_i
	end

	plus_rooms = plus_rooms 
	stories = listing.at_css("tr[2] td tr[2] td").text.strip 
	acreage = listing.at_css("tr[2] td tr[2] td[3]").text.strip 
	bedrooms = bedrooms
	dens = dens
	washrooms = listing.at_css("tr[2] td tr[3] td[4]").text.strip	 
	lot_first_dimension = lot_first_dimension
	lot_second_dimension = lot_second_dimension
	lot_dimension_units = lot_dimension_units
	lot_square_footage = lot_first_dimension*lot_second_dimension
	mls = listing.at_css("tr[3] td tr td").text.strip.gsub(/\p{Space}/,"")
	kitchens = listing.at_css("tr[4] td tr td").text.strip
	fam_rm = listing.at_css("tr[4] td tr[2] td").text.strip
	basement = listing.at_css("tr[4] td tr[3] td").text.strip
	fireplace = listing.at_css("tr[4] td tr[5] td").text.strip
	sq_foot = listing.at_css("tr[4] td tr[10] td").text.strip
	park_method = listing.at_css("tr[4] td[2] tr[3] td").text.strip
	garage_type = garage_type
	garages = garages
	parking_spaces = listing.at_css("tr[4] td[2] tr[5] td").text.strip
	pool = listing.at_css("tr[4] td[2] tr[7] td").text.strip
	image_urls = image_urls
	image_descriptions = image_descriptions
	description = listing.at_css("tr[6] table").text.strip



	house = {
		address: address,
		address_two: address_two,
		unit_type: unit_type, 
		fronting: fronting, 
		rooms: rooms, 
		plus_rooms: plus_rooms, 
		stories: stories, 
		acreage: acreage, 
		bedrooms: bedrooms,
		dens: dens,
		washrooms: washrooms,	 
		lot_first_dimension: lot_first_dimension,
		lot_second_dimension: lot_second_dimension,
		lot_dimension_units: lot_dimension_units,
		lot_square_footage: lot_first_dimension*lot_second_dimension,
		mls: mls, 
		kitchens: kitchens,
		fam_rm: fam_rm,
		basement: basement,
		fireplace: fireplace,
		sq_foot: sq_foot,
		park_method: park_method,
		garage_type: garage_type,
		garages: garages,
		parking_spaces: parking_spaces,
		pool: pool,
		image_urls: image_urls,
		image_descriptions: image_descriptions,
		description: description,
	}



	def save_house(house)
		@house = House.new(house)
		unless @house.save
			puts "Error: "+ @house.errors.full_messages[0] + ": " + house[:address]
		end					
	end

	save_house(house)

end
def parse_non_house(listing, address)


	unit_type = listing.at_css("tr[2] td tr td").text.strip 
	washrooms = listing.at_css("tr[2] td tr[3] td[6]").text.strip
	corp = listing.at_css("tr[2] td tr[4] td[2]").text.strip
	prop_mgmt =  listing.at_css("tr[5] td").text.strip.gsub(/Prop Mgmt:\S/,"")
	kitchens = listing.at_css("tr[4] td tr td").text.strip
	fam_rm = listing.at_css("tr[4] td tr[2] td").text.strip
	apx_age = listing.at_css("tr[4] td tr[8] td").text.strip
	exposure = listing.at_css("tr[4] td tr[10] td").text.strip
	pets = listing.at_css("tr[4] td[2] tr[1] td").text.strip
	locker = listing.at_css("tr[4] td[2] tr[2] td").text.strip
	maintenance = listing.at_css("tr[4] td[2] tr[3] td").text.strip.gsub("$","").gsub(",","").to_i
	level = listing.at_css("tr[2] td tr[3] td[4]").text.strip	 	
	unit_number = listing.at_css("tr[2] td tr[4] td[4]").text.strip
	air_con = listing.at_css("tr[4] td[2] tr[4] td").text.strip
	incl_heat = listing.at_css("tr[4] td[2] tr[10] td").text.strip
	incl_cabl = listing.at_css("tr[4] td[2] tr[11] td").text.strip
	incl_cac = listing.at_css("tr[4] td[2] tr[11] td[4]").text.strip
	incl_insurance = listing.at_css("tr[4] td[2] tr[12] td").text.strip
	incl_comm_elem = listing.at_css("tr[4] td[2] tr[13] td").text.strip
	incl_water = listing.at_css("tr[4] td[2] tr[9] td[4]").text.strip
	incl_hydro = listing.at_css("tr[4] td[2] tr[10] td[4]").text.strip
	incl_parking = listing.at_css("tr[4] td[2] tr[12] td[4]").text.strip
	balcony = listing.at_css("tr[4] td[3] tr[1] td").text.strip
	ensuite_laundry = listing.at_css("tr[4] td[3] tr[2] td").text.strip
	laundry_level = listing.at_css("tr[4] td[3] tr[2] td[4]").text.strip
	park_method = listing.at_css("tr[4] td[3] tr[6] td").text.strip
	park_type = listing.at_css("tr[4] td[3] tr[7] td").text.strip
	park_cost = listing.at_css("tr[4] td[3] tr[9] td").text.strip.gsub("$","").gsub(",","").to_i
	description = listing.at_css("tr[6] table").text.strip

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
	
	#parse square footage

	apx_sqft = listing.at_css("tr[4] td tr[9] td").text.strip
	sqft_range_first = 0
	sqft_range_second = 0
	if apx_sqft.include? "-"
		apx_sqft = apx_sqft.split("-")
		sqft_range_first = apx_sqft[0].to_i
		sqft_range_second = apx_sqft[1].to_i
	elsif apx_sqft != ""
		sqft_range_first = apx_sqft.match(/(\d+)/)[0].to_i
		sqft_range_second = apx_sqft.match(/(\d+)/)[0].to_i
	end
	
	# parse exterior
	exterior_one = listing.at_css("tr[4] td[3] tr[3] td").text.strip
	exterior_two = listing.at_css("tr[4] td[3] tr[4] td").text.strip
	exterior = exterior_one + " , " + exterior_two

	# parse parking spaces
	park_spaces = listing.at_css("tr[4] td[3] tr[8] td").text.strip
	if /(\d+)/.match(park_space).nil?
		park_spaces = 0
	else
		park_spaces = park_spaces.match(/(\d+)/)[0].to_i
	end

	# parse amenities
	total_rows = listing.search("tr[4]/td[3]/table/tr").size
	amenities = ""
	if total_rows = 12
		amenities = listing.at_css("tr[4] td[3] tr[12] td").text.strip
	elsif total_rows > 12
		amenities = listing.at_css("tr[4] td[3] tr[12] td").text.strip
		for i in (12...total_rows)
			amenities << " , " + listing.at_css("tr[4] td[3] tr[#{i}] td").text.strip
		end
	else
		puts "i don't think we should be here, review this..."
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


	non_house = {
		unit_type: unit_type, 
		rooms: rooms, 
		plus_rooms: plus_rooms, 
		bedrooms: bedrooms,
		dens: dens,
		washrooms: washrooms,	 
		corp: corp,
		address: address,
		address_two: address_two,
		prop_mgmt: prop_mgmt,
		kitchens: kitchens,
		fam_rm: fam_rm,
		apx_age: apx_age,
		sqft_range_first: sqft_range_first,
		sqft_range_second: sqft_range_second,
		exposure: exposure,
		pets: pets,
		locker: locker,
		level: level,
		unit_number: unit_number,
		maintenance: maintenance,
		air_con: air_con,
		incl_heat: incl_heat,
		incl_cabl: incl_cabl,
		incl_insurance: incl_insurance,
		incl_comm_elem: incl_comm_elem,
		incl_water: incl_water,
		incl_hydro: incl_hydro,
		incl_cac: incl_cac,
		incl_parking: incl_parking,
		balcony: balcony,
		ensuite_laundry: ensuite_laundry,
		laundry_level: laundry_level,
		exterior: exterior,
		park_method: park_method,
		park_type: park_type,
		park_spaces: park_spaces,
		park_cost: park_cost,
		amenities: amenities,
		description: description,
		image_urls: image_urls,
		image_descriptions: image_descriptions,
	}

	def save_non_house(non_house)
		@non_house = NonHouse.new(non_house)
		unless @non_house.save
			puts "Error: "+ @non_house.errors.full_messages[0] + ": " + non_house[:address]
		end					
	end

	save_non_house(non_house)

end
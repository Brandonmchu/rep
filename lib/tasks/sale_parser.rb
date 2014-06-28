def save_sale(listing, address, address_two, property)
	
	#sale hash variables
	list_price = listing.at_css("tr[1] td[2] tr td[2]").text.strip.gsub("$","").gsub(",","").to_i
	sold_price = listing.at_css("tr[1] td[2] tr td[3]").text.strip.gsub("$","").gsub(",","").to_i
	original_price = listing.at_css("tr[1] td[2] table[2] tr td").text.strip.gsub("$","").gsub(",","").to_i
	taxes = listing.at_css("tr[1] td[2] table[2] tr td[4]").text.strip.gsub("$","").gsub(",","")[0..-6].to_i
	days_on_market = listing.at_css("tr[1] td[2] table[3] tr td[4]").text.strip.to_i
	spis = listing.at_css("tr[1] td[2] table[3] tr td[2]").text.strip
		#parse dates into date objects so that they can be injected into database
	list_date = listing.at_css("tr[1] td[2] table[3] tr td[6]").text.strip
	sold_date = listing.at_css("tr[1] td[2] table[3] tr td[8]").text.strip
	list_date = Date.strptime(list_date,'%m/%d/%Y')
	sold_date = Date.strptime(sold_date,'%m/%d/%Y')


	if property.class.name == "House"
		house_id = property.id
		non_house_id = 0
	else
		house_id = 0
		non_house_id = property.id	
	end
	#sale hash
	sale = {
		address: address,
		address_two: address_two,
		list_price: list_price,
		sold_price: sold_price,
		original_price: original_price, 
		taxes: taxes,
		days_on_market: days_on_market,
		spis: spis,
		list_date: list_date,
		sold_date: sold_date,
		house_id: house_id,
		non_house_id: non_house_id,
		longitude: property.longitude,
		latitude: property.latitude	 
	}

	@sale = Sale.new(sale)
	unless @sale.save
		puts "SALE Error: "+@sale.class.name+" "+@sale.errors.full_messages[0] + ": " + sale[:address]
	end

end
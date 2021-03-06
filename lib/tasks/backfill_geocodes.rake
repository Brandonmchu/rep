desc "Fetches transactions and figures out Bookvalue of shares"
task :backfill_geocodes => :environment do

houses = House.where(longitude: nil)
houses.each do |house|
	if house.geocode == nil
		sleep(1)
		puts "Can't find a geocode for house_id:#{house.id}"
	else
		coords = house.geocode
		sleep(1)
		house.update!(latitude: coords[0], longitude: coords[1])
		house.sales.each do |sale|
			sale.update!(latitude: house.latitude, longitude: house.longitude)
		end
	end
end

non_houses = NonHouse.where(longitude: nil)
non_houses.each do |non_house|
	if non_house.geocode == nil
		sleep(1)
		puts "Can't find a geocode for non_house_id:#{non_house.id}"
	else
		coords = non_house.geocode
		sleep(1)
		puts "currently working on #{non_house.id}"
		non_house.update!(latitude: coords[0], longitude: coords[1])
		non_house.sales.each do |sale|
			sale.update!(latitude: non_house.latitude, longitude: non_house.longitude)
		end
	end
end

end
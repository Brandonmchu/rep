desc "Checks if new sales have occurred today and notifies users"
task :send_email => :environment do 
	
	@users = User.all

	@users.each do |one_user|

		lois = one_user.locations_of_interest
		sales = []
		lois.each do |location|
			coords = Geocoder.coordinates(location)
			latitude = coords[0]
			longitude = coords[1]
			proximity = 1000
			date = Time.now - 1.day

			@sales_near_by = Sale.find_by_sql ["SELECT *,earth_distance(ll_to_earth(?,?), ll_to_earth(s.latitude, s.longitude)) as distance_from_current_location FROM sales s WHERE earth_box(ll_to_earth(?,?),?) @> ll_to_earth(s.latitude,s.longitude) AND s.sold_date > ? ORDER BY distance_from_current_location ASC",latitude,longitude,latitude,longitude,proximity,date]

			unless @sales_near_by.empty?
				@sales_near_by.each do |sale|
					sales.append(sale)
				end
			end
		end

		unless sales.empty?
			UserMailer.email_user(one_user,sales).deliver
		end
	end
end
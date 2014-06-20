desc "Fetches transactions and figures out Bookvalue of shares"
task :fetch_sales => :environment do

require 'open-uri'

	# connect to Gmail
	gmail = Gmail.connect("rep.pricelist@gmail.com", "Pricesforall")
	# get body of email from gmail
	# add :unread to emails(...) to get only the unread one
	urls = []
	mail = gmail.inbox.emails(:from => "sold.watch@gmail.com", :subject => "Toronto Real Estate Sold")
	note = mail.last.body

	# log out of gmail
	gmail.logout

	#regex the email only for the html_section of the email, then use Nokogiri to parse, replacing some odd characters
	html_section = /(<!(.|\s)*html>)/
	note = note.match(html_section)[0].gsub("=\n",'').gsub("3D","").gsub("CL",'CL_CF')
	html_doc = Nokogiri::HTML(note)
	
	#build array of urls with listings
	html_doc.search('//h3[text()="All GTA"]/following-sibling::ul[1]/li/a/@href').each do |url|
		url = url.text
		url << "&t=l&fm=M"
		urls << url 
	end

	#open each url, identify the details of each listing, parse details and save to db
	urls.each do |url|

		doc = Nokogiri::HTML(open(url))
		#parse for the table of listings
		listings = doc.css("table")

		listings.each do |listing|
			# if an border = 1 then we have a listing
			if listing.attr("border") == "1"
				
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

				#parse dates into date objects so that they can be injected into database
				date_list = listing.at_css("tr[1] td[2] table[3] tr td[6]").text.strip
				date_sold = listing.at_css("tr[1] td[2] table[3] tr td[8]").text.strip
				date_list = Date.strptime(date_list,'%m/%d/%Y')
				date_sold = Date.strptime(date_sold,'%m/%d/%Y')

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

				# parse lot into dimensions
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

				#parse garage into garage type and number of garages
				gargae_type = "Not Available"
				garages = 0
				garage_details = listing.at_css("tr[4] td[2] tr[4] td").text.strip
				if garage_details.include? "/"
					garage_details = garage_details.split("/")
					garage_type = garage_details[0]
					garages = garage_details[1]
				end

				#sale hash
				sale = {
					address: listing.at_css("tr[1] td[2] tr td").text.strip,
					listprice: listing.at_css("tr[1] td[2] tr td[2]").text.strip.gsub("$","").to_i,
					soldprice: listing.at_css("tr[1] td[2] tr td[3]").text.strip.gsub("$","").to_i,
					original_price: listing.at_css("tr[1] td[2] table[2] tr td").text.strip.gsub("$","").to_i, 
					taxes: listing.at_css("tr[1] td[2] table[2] tr td[4]").text.strip.gsub("$","").gsub(",","")[0..-6].to_i,
					days_market: listing.at_css("tr[1] td[2] table[3] tr td[4]").text.strip.to_i, 
					date_list: date_list,
					date_sold: date_sold, 
					unit_type: listing.at_css("tr[2] td tr td").text.strip, 
					fronting: listing.at_css("tr[2] td tr td[3]").text.strip, 
					rooms: rooms, 
					plus_rooms: plus_rooms, 
					stories: listing.at_css("tr[2] td tr[2] td").text.strip, 
					acreage: listing.at_css("tr[2] td tr[2] td[3]").text.strip, 
					bedrooms: bedrooms,
					dens: dens,
					washrooms: listing.at_css("tr[2] td tr[3] td[4]").text.strip,	 
					lot_first_dimension: lot_first_dimension,
					lot_second_dimension: lot_second_dimension,
					lot_dimension_units: lot_dimension_units,
					lot_square_footage: lot_first_dimension*lot_second_dimension,
					mls: listing.at_css("tr[3] td tr td").text.strip.gsub(/\p{Space}/,''), 
					kitchens: listing.at_css("tr[4] td tr td").text.strip,
					fam_rm: listing.at_css("tr[4] td tr[2] td").text.strip,
					basement: listing.at_css("tr[4] td tr[3] td").text.strip,
					fireplace: listing.at_css("tr[4] td tr[5] td").text.strip,
					sq_foot: listing.at_css("tr[4] td tr[10] td").text.strip,
					mutual: listing.at_css("tr[4] td[2] tr[3] td").text.strip,
					garage_type: garage_type,
					garages: garages,
					parking_spaces: listing.at_css("tr[4] td[2] tr[5] td").text.strip,
					pool: listing.at_css("tr[4] td[2] tr[7] td").text.strip,
					image_urls: image_urls,
					image_descriptions: image_descriptions
				}

				@sale = Sale.new(sale)

				unless @sale.save
					puts "Error: "+ @sale.errors.full_messages[0] + ": " + sale[:address]
				end

			end
		end	
	end
end
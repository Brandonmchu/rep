desc "Fetches transactions and figures out Bookvalue of shares"
task :fetch_sales => :environment do

require 'open-uri'

# def clean(range, note)
# 	node = note.match range
# 	node[0].gsub("3D","").sub("CL",'CL_CF') << "&t=l&fm=M"
# end

gmail = Gmail.connect("rep.pricelist@gmail.com", "Pricesforall")
	
	# get body of email from gmail
	# add :unread to emails(...) to get only the unread one
	urls = []
	mail = gmail.inbox.emails(:from => "sold.watch@gmail.com", :subject => "Toronto Real Estate Sold")
	note = mail.last.body

gmail.logout

	html_section = /(<!(.|\s)*html>)/
	note = note.match(html_section)[0].gsub("=\n",'').gsub("3D","").gsub("CL",'CL_CF')
	html_doc = Nokogiri::HTML(note)
	
	html_doc.search('//h3[text()="All GTA"]/following-sibling::ul[1]/li/a/@href').each do |url|
		url = url.text
		url << "&t=l&fm=M"
		puts url.class
		urls << url 
	end

	puts urls

	urls.each do |url|
		doc = Nokogiri::HTML(open(url))
		listings = doc.css("table")
		listings.each do |listing|
			if listing.attr("border") == "1"
				
				images = listing.at_css("tr td script") 
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
				sale = {
					address: listing.at_css("tr[1] td[2] tr td").text.strip,
					listprice: listing.at_css("tr[1] td[2] tr td[2]").text.strip.gsub("$","").to_i,
					soldprice: listing.at_css("tr[1] td[2] tr td[3]").text.strip.gsub("$","").to_i,
					original_price: listing.at_css("tr[1] td[2] table[2] tr td").text.strip.gsub("$","").to_i, 
					taxes: listing.at_css("tr[1] td[2] table[2] tr td[4]").text.strip.gsub("$","").gsub(",","")[0..-6].to_i,
					days_market: listing.at_css("tr[1] td[2] table[3] tr td[4]").text.strip.to_i, 
					date_list: listing.at_css("tr[1] td[2] table[3] tr td[6]").text.strip,
					date_sold: listing.at_css("tr[1] td[2] table[3] tr td[8]").text.strip, 
					unit_type: listing.at_css("tr[2] td tr td").text.strip, 
					fronting: listing.at_css("tr[2] td tr td[3]").text.strip, 
					rooms: listing.at_css("tr[2] td tr td[5]").text.strip, 
					stories: listing.at_css("tr[2] td tr[2] td").text.strip, 
					acreage: listing.at_css("tr[2] td tr[2] td[3]").text.strip, 
					bedrooms: listing.at_css("tr[2] td tr[2] td[5]").text.strip,	 
					lot: listing.at_css("tr[2] td tr[4] td[2]").text.strip, 
					mls: listing.at_css("tr[3] td tr td").text.strip.gsub(/\p{Space}/,''), 
					kitchens: listing.at_css("tr[4] td tr td").text.strip,
					fam_rm: listing.at_css("tr[4] td tr[2] td").text.strip,
					basement: listing.at_css("tr[4] td tr[3] td").text.strip,
					fireplace: listing.at_css("tr[4] td tr[5] td").text.strip,
					sq_foot: listing.at_css("tr[4] td tr[10] td").text.strip,
					mutual: listing.at_css("tr[4] td[2] tr[3] td").text.strip,
					garage_type: listing.at_css("tr[4] td[2] tr[4] td").text.strip,
					parking_spaces: listing.at_css("tr[4] td[2] tr[5] td").text.strip,
					pool: listing.at_css("tr[4] td[2] tr[7] td").text.strip,
					image_urls: image_urls,
					image_descriptions: image_descriptions
				}
				@sale = Sale.new(sale)
				if @sale.save
					puts "saved correctly - "+sale[:address]
				else
					puts "did not save due to error - "+sale[:address]+@sale.errors.full_messages[0]
				end
			end
		end	
	end
end
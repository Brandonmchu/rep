desc "Fetches transactions and figures out Bookvalue of shares"
task :fetch_sales => :environment do

require 'open-uri'
require './lib/tasks/house_parser'
require './lib/tasks/sale_parser'

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

				address = listing.at_css("tr[1] td[2] tr td").text.strip
				address_two = listing.at_css("tr[1] td[2] tr[2] td").text.strip

				lot = listing.at_css("tr[2] td tr[4] th[1]").text.strip
				if lot == "Lot:"
					parse_house(listing, address, address_two)
				else
					puts "Not a house!"
				end

				# save_sale(listing, address, address_two)


				#find out if house or non_house and then pass to parsing functions
					
			end
		end	
	end
end
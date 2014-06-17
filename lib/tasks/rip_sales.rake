desc "Fetches transactions and figures out Bookvalue of shares"
task :fetch_sales => :environment do
	# require 'mime'
require 'gmail'
require 'Nokogiri'
require 'open-uri'

def clean(range, note)
	node = note.match range
	node[0].gsub("3D","").sub("CL",'CL_CF') << "&t=l&fm=M"
end

gmail = Gmail.connect(ENV["GMAIL_EMAIL"], ENV["GMAIL_PASSWORD"])
	
	# get body of email from gmail
	# add :unread to emails(...) to get only the unread one
	mail = gmail.inbox.emails(:unread, :from => ENV["FWDEMAIL"], :subject => "Fwd: Toronto Real Estate Sold")
	note = mail.first.body
	
	# regex to parse body
	four = /(?<=Under \$400,000 \=C2\=BB
   <http:\/\/)[^>]*/
	five = /(?<=\$400,000 to \$500,000 \=C2\=BB
   <http:\/\/)[^>]*/
	six = /(?<=\$500,000 to \$600,000 \=C2\=BB
   <http:\/\/)[^>]*/
	eight = /(?<=\$600,000 to \$800,000 \=C2\=BB
   <http:\/\/)[^>]*/
	infinite = /(?<=Over \$800,000 \=C2\=BB
   <http:\/\/)[^>]*/

	urls = []
	urls << clean(four,note) << clean(five,note) << clean(six,note) << clean(eight,note) << clean(infinite,note)
	print urls

gmail.logout

	url = 'http://www.torontomls.net/PublicWeb/CL_CF.asp?link_no=53199289.059400&t=l&fm=M'
	doc = Nokogiri::HTML(open(url))
	listings = doc.css("table")

	listings.each do |listing|
		if listing.attr("border") == "1"
			
			images = listing.at_css("tr td script") 
			all_links_regex = /(?<=pixArray = new Array\()[^\)]*/
			parsed_links_regex = /(?<=,|^)'\K[^?]+/
			image_descriptions_regex = /(?<=commArray = new Array\()[^\)]*/
			parsed_descriptions_regex = /[^,]+/
			
			sale = {
				address: listing.at_css("tr[1] td[2] tr td").text,
				listprice: listing.at_css("tr[1] td[2] tr td[2]").text,
				soldprice: listing.at_css("tr[1] td[2] tr td[3]").text,
				original_price: listing.at_css("tr[1] td[2] table[2] tr td").text, 
				taxes: listing.at_css("tr[1] td[2] table[2] tr td[4]").text,
				days_market: listing.at_css("tr[1] td[2] table[3] tr td[4]").text, 
				date_list: listing.at_css("tr[1] td[2] table[3] tr td[6]").text,
				date_sold: listing.at_css("tr[1] td[2] table[3] tr td[8]").text, 
				unit_type: listing.at_css("tr[2] td tr td").text, 
				fronting: listing.at_css("tr[2] td tr td[3]").text, 
				rooms: listing.at_css("tr[2] td tr td[5]").text, 
				stories: listing.at_css("tr[2] td tr[2] td").text, 
				acreage: listing.at_css("tr[2] td tr[2] td[3]").text, 
				bedrooms: listing.at_css("tr[2] td tr[2] td[5]").text, 
				lot: listing.at_css("tr[2] td tr[4] td[2]").text, 
				mls: listing.at_css("tr[3] td tr td").text.gsub(/\p{Space}/,''), 
				kitchens: listing.at_css("tr[4] td tr td").text,
				fam_rm: listing.at_css("tr[4] td tr[2] td").text,
				basement: listing.at_css("tr[4] td tr[3] td").text,
				fireplace: listing.at_css("tr[4] td tr[5] td").text,
				sq_foot: listing.at_css("tr[4] td tr[10] td").text,
				mutual: listing.at_css("tr[4] td[2] tr[3] td").text,
				garage_type: listing.at_css("tr[4] td[2] tr[4] td").text,
				parking_spaces: listing.at_css("tr[4] td[2] tr[5] td").text,
				pool: listing.at_css("tr[4] td[2] tr[7] td").text,
				image_urls: all_links_regex.match(images)[0].scan(parsed_links_regex),
				image_descriptions: image_descriptions_regex.match(images)[0].scan(parsed_descriptions_regex)
			}
			Sale.create!(sale)
		end
	end	

end
class Sale < ActiveRecord::Base

	validates :address, :date_sold, :soldprice, :listprice, presence: true
	validates :address, uniqueness: {scope: :date_sold}

end

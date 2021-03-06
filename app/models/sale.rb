class Sale < ActiveRecord::Base

	validates :address, :sold_date, :sold_price, :list_price, presence: true
	validates :address, uniqueness: {scope: :sold_date}

	belongs_to :house
	belongs_to :non_house

end

class NonHouse < ActiveRecord::Base

	validates :address, presence: true
	validates :address, uniqueness: true

	has_many :sales

end

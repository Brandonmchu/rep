class UsersController < ApplicationController

	def create
		@existing = User.find_by_email(params['email'])
		if @existing.nil?
			@new = User.new(email: params['email'],locations_of_interest: [params['locations_of_interest']])
			if @new.save
				render plain: "Thanks for subscribing! We'll send you sales near this location when they occur."
			else
				render plain: 'failed to save user and location'
			end
		else
			if @existing.locations_of_interest.include?(params['locations_of_interest'])
				render plain: "Thanks for your interest but we noticed this location has already been saved for you and we don't want to spam you!"
			else
				if @existing.update_attributes(locations_of_interest: @existing.locations_of_interest + [params['locations_of_interest']])
					render plain: 'Added location to your list of interested locations'
				else
					render plain: 'failed to save location'	
				end
			end
		end
	end


end

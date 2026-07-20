class PagesController < ApplicationController
	def home
		@restaurants = Restaurant.all
		# @itmes = MenuItem.includes(:menu_category).where(available: true).order(:name).limit(5)
	end

	def contact
		@restaurant = Restaurant.first
	end


end

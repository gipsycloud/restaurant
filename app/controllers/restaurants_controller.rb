class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show]

  def index
    @restaurants = Restaurant.includes(:tables, :menus).order(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])

    @total_tables = @restaurant.tables.count
    @occupied_tables = @restaurant.tables.occupied.count
    @available_tables = @total_tables - @occupied_tables
    
    # Today's Orders & Revenue
    @today_orders = @restaurant.orders.where(created_at: Date.today.all_day)
    @today_revenue = @today_orders.paid.sum(:total_amount) || 0
    
  end

  private

  def set_restaurant
    @restaurant = Restaurant.includes(:tables).find(params[:id])
  end
end

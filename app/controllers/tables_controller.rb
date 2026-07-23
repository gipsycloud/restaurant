class TablesController < ApplicationController
	before_action :set_restaurant
	before_action :set_table, only: [:show, :edit, :update, :destroy]
	def index
		@tables = @restaurant.tables.includes(:reservations, :orders).order(:table_number)
	end

	def show
		@current_reservation = @table.reservations.where(status: :confirmed).last
    	@current_order = @table.orders.where.not(status: [:completed, :cancelled]).last
	end

	def new
		@table = Table.new
	end

	def createt
		@table = Table.new(table_params)
		if @table.save
			redirect_to @table, notice: 'Table was successfully created.'
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @table.update(table_params)
			redirect_to @table, notice: 'Table was successfully updated.'
		else
			render :edit
		end
	end

	def destroy
		@table.destroy
		redirect_to tables_url, notice: 'Table was successfully destroyed.'
	end

	private

	 def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
    end

	def set_table
		@table = Table.find(params[:id])
	end

	def table_params
		params.require(:table).permit(:restaurant_id, :table_number, :capacity, :status)
	end
end

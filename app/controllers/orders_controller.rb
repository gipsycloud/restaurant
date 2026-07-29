class OrdersController < ApplicationController
	before_action :set_order, only: [:show, :edit, :update, :destroy]
	before_action :set_restaurant

	def index
		@orders = @restaurant.orders.includes(:order_items, :table, :payment)
		@orders = @orders.where(status: params[:status]) if params[:status].present?
		@orders = @orders.where(payment_status: params[:payment_status]) if params[:payment_status].present?
		@orders = @orders.where("created_at >= ?", params[:from_date]) if params[:from_date].present?
    @orders = @orders.where("created_at <= ?", params[:to_date]) if params[:to_date].present?
	end

	def show
		# @order = @restaurant.orders.find(params[:id])
	end

	def new
		@order = @restaurant.orders.build
	end

	def create
		@order = @restaurant.orders.new(order_params)
		if @order.save
			redirect_to restaurant_order_path(@restaurant, @order), notice: 'Order was successfully created.'
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @order.update(order_params)
			redirect_to restaurant_order_path(@restaurant, @order), notice: 'Order was successfully updated.'
		else
			render :edit
		end
	end

	def destroy
		@order.destroy
		redirect_to restaurant_orders_path(@restaurant), notice: 'Order was successfully destroyed.'
	end

	def generate_receipt
		@order = Order.find(params[:id])

		ReceiptJob.perform_async(@order.id)
		redirect_to restaurant_order_path(@restaurant, @order), notice: "Receipt is generating."
	end

	private

	def set_restaurant
		@restaurant = Restaurant.find(params[:restaurant_id])
	end

	def set_order
		@order = Order.find(params[:id])
	end

	def order_params
		params.require(:order).permit(:table_id, :status, :total_amount, :reservation_id, :payment_status, order_items_attributes: [:menu_item_id, :quantity])
	end
end

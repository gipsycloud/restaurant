class ReservationsController < ApplicationController
    before_action :set_restaurant
    before_action :set_reservation, only: [:show, :edit, :update,

    def index
        @reservations = @restaurant.reservations.includes(:table)
        @reservations = @reservations.where("reserved_at >= ?", Date.today).order(reserved_at: :asc) if params[:upcoming] == 'true'
        @reservations = @reservations.where("status = ?", params[:status]) if params[:status].present?
    end

    def show
    end
    
    def new
        @reservation = @restaurant.reservations.build
    end

    def create
        @reservation = @restaurant.reservations.build(reservation_params)
        if @reservation.save
						# SendReservationConfirmationJob.perform_later(@reservation)
            redirect_to [@restaurant, @reservation], notice: "Reservation was successfully created."
        else
            render :new, status: unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @reservation.update(reservation_params)
            redirect_to [@restaurant, @reservation], notice: "Reservation was successfully updated."
        else
            render :edit, status: unprocessable_entity
        end
    end

    def destroy
        @reservation.destroy!
        redirect_to restaurant_reservations_path(@restaurant), notice: "Reservation was successfully deleted"
    end

    private

    def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_reservation
        @reservation = @restaurant.reservations.find(params[:id])
    end

    def reservation_params
        params.require(:reservation).permit(:table_id, :customer_name, :phone, :guest_count, :reserved_at, :status)
    end
end

class UsersController < ApplicationController
    before_action :set_restaurant
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
        @users = @restaurant.users
    end

    def show
    end

    def new
        @user = @restaurant.users.build
    end

    def create
        @user = @restaurant.users.build(set_user_params)
        if @user.save
            redirect_to [@restaurant, @user], notice: "User was successfully created."
        else
            render :new, status: unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @user.update(set_user_params)
            redirect_to [@restaurant, @user], notice: "User was successfully updated."
        else
            render :edit, status: unprocesable_entity
        end
    end

    def destroy
        @user.destroy!
        redirect_to restaurant_users_path(@restaurant), notice: "User was successfully deleted"
    end

    private

    def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_user
        @user = @restaurant.users.find(params[:id])
    end

    def set_user_params
        params.require(:user).permit(:name, :email, :role)
    end
end

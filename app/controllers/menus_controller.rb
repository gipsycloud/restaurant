class MenusController < ApplicationController

    def index
        @menus = @restaurant.menus.available
    end

    def show
    end

    def new
    end

    def create
        @menu = @restaurant.menus.create!(menu_params)
        if @menu.save
            redirect_to @menu, notice: "Menu was successfully created"
        else
            render :new, status: unprocesable_entity
        end
    end

    def edit
    end

    def update
        if @menu.update(menu_params)
            redirect_to @menu, notice: "Menu was successfully updated"
        else
            render :edit, status: unprocesable_entity
        end
    end

    def destroy
        @menu.destroy!
        redirect_to restaurant_menus_path(@restaurant), notice: "Menu was successfully deleted"
    end

    private
    def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_menu
        @menu = @restaurant.menus.find(params[:id])
    end

    def menu_params
        params.require(:menu).permit(:name, :description, :price)
    end
end

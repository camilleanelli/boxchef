class MealsController < ApplicationController

  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_meal, only: [:show, :edit, :update, :destroy]

  def index
    @meals = Meal.all.order('created_at DESC').page(params[:page])

  end

  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def new
    @meal = Meal.new
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def create
    @meal = Meal.new(params_meal)
    restaurant_id = Restaurant.find(params[:id])
    if @meal.save
      redirect_to restaurant_meals_path(@meal)
    else
       render :new
     end
  end

  def edit

     @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def update
    @meal.update(params_meal)
    if @meal.save
    redirect_to meal_path(@meal)
    else
    render :edit
    end
  end

  def destroy
    if @meal.delete
      redirect_to meals_path
    else
      render :destroy
    end
  end

  private

  def set_meal
    @restaurant = Restaurant.find(params[:restaurant_id])
    @meal = @restaurant.meals.find(:meal_id)
  end

  def params_meal
    params.require(:meal).permit(:name, :description, :price, :quantity, :picture, :starting_date, :take_away_noon_starts_at, :take_away_evening_starts_at, :take_away_noon_ends_at, :take_away_evening_ends_at)
  end

end
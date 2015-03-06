class FoodsController < ApplicationController
  service(:meals) { Meal.for_user_id(current_user.id) }

  template_attr :food

  def new
    self.food = meal.new_food
  end

  def create
    self.food = meal.create_food(food_params)
    if food.valid?
      redirect_to daily_scorecard_path(daily_scorecard_path_params)
    else
      render action: :new, status: 422
    end
  end

  def daily_scorecard_path_params
    date_params_from(meal.consumed_at)
  end
  helper_method :daily_scorecard_path_params

  private

  def meal
    @meal ||= meals.find(params.require(:meal_id))
  end

  def food_params
    params.require(:food).permit(:name, *Food.servings_fields)
  end
end

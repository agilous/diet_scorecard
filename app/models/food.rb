require_dependency 'diet_scorecard/food_type'

class Food < ActiveRecord::Base
  belongs_to :meal
  serialize :servings, Hash

  @@servings_fields = []

  DietScorecard::FoodType.each do |ft|
    field_name = "#{ft.key}_servings"
    @@servings_fields << field_name

    puts "defining methods for #{field_name}"
    define_method(field_name) do
      servings_of(ft.key)
    end

    define_method("#{field_name}=") do |value|
      servings[ft.key] = value
    end

    validates field_name, numericality: {only_integer: true}
  end

  def servings_of(food_type)
    servings.fetch(food_type, 0)
  end

  def servings_fields
    @@servings_fields.dup
  end
end
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :clean_input

  def clean_input(string)
    string = string.gsub(/[()\[\]]/, ",")
    ingredients = string.split(",")
    puts "HERE"
    puts ingredients
    ingredients.each do |ingredient|
      ingredient.slice!(0) if (ingredient[0] == " ")
      ingredient.slice!(-1) if (ingredient[-1] == " ")
      ingredients.delete("")
      ingredients.delete(". ")
    end
    return ingredients
  end

end

require 'httparty'

class IngredientsController < ApplicationController

  def lookup
    upc = params[:upc]
    id = params[:id]
    response = HTTParty.get("http://world.openfoodfacts.org/api/v9/product/#{upc}.json",
      headers: { "Accept" => "application/json",
        "User-Agent" => "IngredientInspector/1.0"})
    ingredients = response.parsed_response["product"]["ingredients_text"]
    ingredients = clean_input(ingredients)

    #code to run all of the queries, plus manufacturer API
    data = {
          "ingredients" => "array of hashes?",
          "manufacturer_contact" => "email_goes_here",
          "a" => ingredients
        }

    render json: data.as_json, :status => :ok

    rescue HTTParty::ResponseError #FIX ERROR HANDLING
        render json: [], :status => :bad_request

  end

end

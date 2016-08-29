require 'httparty'

class IngredientsController < ApplicationController

  def lookup
    upc = params[:upc]
    id = params[:id]
    #code to fetch from cache here
    data = Rails.cache.fetch("#{upc}/upc")
    if data.nil?
      response = HTTParty.get("http://world.openfoodfacts.org/api/v9/product/#{upc}.json",
        headers: { "Accept" => "application/json",
          "User-Agent" => "IngredientInspector/1.0"})
      puts response

      if response.parsed_response["status"]==0
        data = response.parsed_response["status_verbose"]
      elsif response.parsed_response["product"]["ingredients_text"] == ""
        #code to search secondary food database!!!
        data = { product: product, brand: brand, message: "No ingredients added"}
      else
        all_ingredients = response.parsed_response["product"]["ingredients_text"]
        ingredients = clean_input(all_ingredients)
        product = response.parsed_response["product"]["product_name"]
        brand = response.parsed_response["product"]["brands"]
        contact = fetch_contact(fetch_manufacturer(brand))
        domain = fetch_manufacturer(brand)
        packaging_info = response.parsed_response["product"]["packaging_tags"]
      # async script to get manufacturer domain => contact info
      #code to run all of the db queries locally

      #NEXT: Change ingredient call to only return ingredients, SAVE info to make following calls upon user request! Use "log" style saves
      flagged_ingredients = []
      ingredients.each do |ingredient|
        this = Ingredient.find_by(name: ingredient)
        if this
          puts this
          flagged_ingredients << this
        end
      end
      if flagged_ingredients.empty?
        flagged_ingredients = "No flagged ingredients"
      end
      data = {
            "ingredients" => flagged_ingredients,
            "manufacturer_contact" => contact,
            "product" => product,
            "brand" => brand,
            "domain" => domain,
            "packaging" => packaging_info,
            "message" => "found",
            "status" => "ok"
          }
      end
      Rails.cache.fetch("#{upc}/upc", expires_in: 200.hours) do
        data
      end
    end

      render json: data.as_json, :status => :ok
  end

  def test
    return true
  end

end

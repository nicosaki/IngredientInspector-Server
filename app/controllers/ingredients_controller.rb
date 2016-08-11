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

      if (response.parsed_response["status"]==0)
        data = response.parsed_response["status_verbose"]
      elsif (response.parsed_response["product"]["ingredients_text"] == "")
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
      data = {
            "ingredients" => ingredients,
            "manufacturer_contact" => contact,
            "product" => product,
            "brand" => brand,
            "domain" => domain,
            "packaging" => packaging_info
          }
      end
      Rails.cache.fetch("#{upc}/upc", expires_in: 200.hours) do
        data
      end
    end

      render json: data.as_json, :status => :ok

      # render json: [], :status => :bad_request
  end

  def test
    # array = ["corn syrup", "modified food starch", "citric acid", "malic acid", "fumaric acid", "dextrin", "carnauba wax", "triglycerides", "tartrazine"]
    hold = search_parent("Lay's")
    # array.each do |ingredient|
    #   this = Ingredient.find_by(name: ingredient)
    #   puts this
    #   if this
    #     hold << ingredient
    #     puts this.status
    #     puts this.warnings
    #   end
    # end
    # details = Ingredient.where(status: nil, warnings: nil)
    # details = fetch_contact("http://misttwst.com/")
    # puts details.length
    # ingredients = Ingredient.all
    # ingredients.each do |ingredient|
    #   hold << [ingredient.name, ingredient.status, ingredient.warnings]
    # end
    render json: hold.as_json
  end

end

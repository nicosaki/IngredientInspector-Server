require 'httparty'

class IngredientsController < ApplicationController

  def lookup
    upc = params[:upc]
    id = params[:id]
    response = HTTParty.get("http://world.openfoodfacts.org/api/v9/product/#{upc}.json",
      headers: { "Accept" => "application/json",
        "User-Agent" => "IngredientInspector/1.0"})
    puts response
    if (response.parsed_response["status"]==0)
      render json: response.parsed_response["status_verbose"].as_json
    elsif (response.parsed_response["product"]["ingredients_text"] == "")
      #code to search secondary food database!!!
      product = response.parsed_response["product"]["product_name"]
      brand = response.parsed_response["product"]["brands"]
      data = { product: product, brand: brand, message: "No ingredients added"}
      render json: data.as_json
    else
      all_ingredients = response.parsed_response["product"]["ingredients_text"]
      ingredients = clean_input(all_ingredients)
      #code to run all of the queries, plus manufacturer API
      data = {
            "all" => all_ingredients,
            "ingredients" => "array of hashes?",
            "manufacturer_contact" => "email_goes_here",
            "a" => ingredients

          }

      render json: data.as_json, :status => :ok

    end
        # render json: [], :status => :bad_request

  end

  def test
    # array = ["carrageenan", "Gluconic acid", "starch", "caramel color"]
    # hold = []
    # array.each do |ingredient|
    #   this = Ingredient.find_by(name: ingredient)
    #   puts this
    #   if this
    #     hold << ingredient
    #   end
    # end
    # details = Ingredient.where(status: nil, warnings: nil)
    details = fetch_contact("http://misttwst.com/")
    # puts details.length
    render json: details
  end

end

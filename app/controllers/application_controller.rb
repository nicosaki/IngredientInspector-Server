class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :clean_input

  def clean_input(string)
    string = string.gsub(/[()\[\]]/, ",").downcase
    ingredients = string.split(",")
    puts "HERE"
    puts ingredients
    ingredients.each do |ingredient|
      ingredient.slice!(0) until (ingredient[0] != " ")
      ingredient.slice!(-1) until (ingredient[-1] != " ")
      ingredients.delete("")
      ingredients.delete(".")
    end
    return ingredients
  end

  def fetch_manufacturer(brand)
    response = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/search?q=#{brand}&count=3&offset=0&mkt=en-us&safesearch=Strict",
      headers: { "Accept" => "application/json",
        "User-Agent" => "IngredientInspector/1.0",
        "Ocp-Apim-Subscription-Key" => ENV['BING_SEARCH_KEY_1'],
        "Authorization" => ENV['BING_SEARCH_KEY_2']})
    url = response["webPages"]["value"][0]["displayUrl"]
    return url
  end

  def fetch_contact(domain)
    response = HTTParty.get("https://api.fullcontact.com/v2/company/lookup.json?domain=#{domain}",
      headers: { "Accept" => "application/json",
        "User-Agent" => "IngredientInspector/1.0",
        "X-FullContact-APIKey" => ENV['FULL_CONTACT_KEY']
        })
    return response
  end
end

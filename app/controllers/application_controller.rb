require 'httparty'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery unless: -> { request.format.json? }
  helper_method :clean_input

  def clean_input(string)
    string = string.gsub(/[()\[\]]/, ",").downcase
    ingredients = string.split(",")
    ingredients.each do |ingredient|
      ingredient.slice!(0) until (ingredient[0] != " ")
      ingredient.slice!(-1) until (ingredient[-1] != " ")
      ingredients.delete("")
      ingredients.delete(".")
    end
    return ingredients
  end

  def fetch_manufacturer(brand)
    url = Rails.cache.fetch("#{brand}/brand")
    if url.nil?
      response = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/search?q=#{brand}&count=3&offset=0&mkt=en-us&safesearch=Strict",
        headers: { "Accept" => "application/json",
          "User-Agent" => "IngredientInspector/1.0",
          "Ocp-Apim-Subscription-Key" => ENV['BING_SEARCH_KEY_1'],
          "Authorization" => ENV['BING_SEARCH_KEY_2']})
      url = response["webPages"]["value"][0]["displayUrl"]
      puts "USED A BING QUERY"
      Rails.cache.fetch("#{brand}/brand", expires_in: 200.hours) do
        url
      end
    end
    return url
  end

  def fetch_contact(domain)
    contact = Rails.cache.fetch("#{domain}/domain")
    # puts contact
    if contact.nil?
      contact = HTTParty.get("https://api.fullcontact.com/v2/company/lookup.json?domain=#{domain}",
        headers: { "Accept" => "application/json",
          "User-Agent" => "IngredientInspector/1.0",
          "X-FullContact-APIKey" => ENV['FULL_CONTACT_KEY']
          })
      puts "USED A FULLCONTACT QUERY"
      unless (contact.code == 202 || contact.code >= 300)
        Rails.cache.fetch("#{domain}/domain", expires_in: 200.hours) do
          contact["socialProfiles"]
        end
      end
    end
    contact ? (return contact["socialProfiles"]) : (return "Queued")
  end

  def contact_manufacturer_email(contact_hash)
    contact = Rails.cache.fetch("#{domain}/domain")
    return true
  end

  #HAS POTENTIAL FOR BRAND SEARCH FUNCTIONALITY, NOT RELIABLY FINDING DESIRED RESULTS. Stretch
  # def search_parent(brand)
  #   parent = Rails.cache.fetch("#{brand}/parent")
  #   if parent.nil?
  #     response = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/search?q=parent company of #{brand} brand&count=3&offset=0&mkt=en-us&safesearch=Strict",
  #       headers: { "Accept" => "application/json",
  #         "User-Agent" => "IngredientInspector/1.0",
  #         "Ocp-Apim-Subscription-Key" => ENV['BING_SEARCH_KEY_1'],
  #         "Authorization" => ENV['BING_SEARCH_KEY_2']})
  #     parent = response["webPages"]["value"][0] #fix with testing!
  #     puts "USED A BING QUERY"
  #     Rails.cache.fetch("#{brand}/parent", expires_in: 200.hours) do
  #       parent
  #     end
  #   end
  #   return parent
  # end

end

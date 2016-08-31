require 'json'
class UsersController < ApplicationController

  def login
    body = JSON.parse request.body.read
    puts body
    # profile = body.profile
    profile = body["profile"]
    name = profile["name"]
    uid = profile["userId"]
    user = User.find_by(uid: uid)
    if user.nil?
      @user = User.create(uid: uid, name: name, concerns: '')
      id = { id: @user.id, concerns: '', avoid: [], approved: [], contacted: []}
      render json: id.as_json
    else
      puts user
      @concerns = user.concerns
      @avoids = Avoid.find_by(uid: user.id)
      @approved = Approved.find_by(uid: user.id)
      @contacted = Contacted.where(uid: user.id, contacted: true)
      id = {id: user.id, concerns: @concerns, avoid: @avoids, approved: @approved, contacted: @contacted}
      # avoid: user.avoid, approved: user.approved, contacted: user.contacted, concerns: concerns}
      render json: id.as_json, :status => :ok
    end
    # render json: { id: 1, avoid: [], approved: [], contacted: [], concerns: ''}
  end

  # def create
  #   uid = params[:uid]
  #   provider = params[:provider]
  #   @user = User.find_or_create_by_uid(uid: uid, provider: provider)
  #   id = { id: @user.id}
  #   render json: id.as_json
  # end

  def update
    id = params[:id]
    body = JSON.parse request.body.read
    if (id && body)
      new_concerns = body["concerns"]  # NONFINAL - gather new concerns
      @user = User.find_by(id: id)
      @user ? (@user.update(concerns: new_concerns)) : (render json: {error: "no user found"}.as_json)
      render json: @user.id.as_json
    else
      render json: {error: "no user found"}.as_json
    end
  end

  def index
    id = params[:id]
    user = User.find_by(id: id)
    if user
      @concerns = user.concerns
      @avoids = Avoid.find_by(uid: user.id)
      @approved = Approved.find_by(uid: user.id)
      @contacted = Contacted.where(uid: user.id, contacted: true)
      contacted = @contacted.map{|record| {product: record.product, brand: record.brand}}
      id = {id: user.id, concerns: @concerns, avoid: @avoids, approved: @approved, contacted: contacted}
      # avoid: user.avoid, approved: user.approved, contacted: user.contacted, concerns: concerns}
      render json: id.as_json, :status => :ok
    else
      render json: [], :status => :no_user
    end
  end

  def approved
    upc = params[:upc]
    id = params[:id]
    if (upc && id)
      @approved = Approved.new(id: id, upc: upc)
      if @approved.save
        @approveds = Approved.where(id: id)
        render json: @approveds.as_json, :status => :ok
      end
    end
    render json: [], :status => :failed_to_save
  end

  def avoid
    upc = params[:upc]
    id = params[:id]
    if (upc && id)
      @avoid = Avoid.new(id: id, upc: upc)
      if @avoid.save
        @avoids = Avoid.where(id: id)
        render json: @avoids.as_json, :status => :ok
      end
    end
    render json: [], :status => :failed_to_save
  end

  # def products
  #   id = params[:id]
  #   @brands = Contacted.find_by(id: id)
  #   render json: @brands.as_json
  # end

  def contact_manufacturer
    # body = JSON.parse request.body.read #POTENTIAL PROVIDE EMAIL/TWITTER PREFERENCE
    upc = params[:upc]
    id = params[:id]
    if (upc && id)
      data = Rails.cache.fetch("#{upc}/upc")
      # response = HTTParty.get("http://world.openfoodfacts.org/api/v9/product/#{upc}.json",
      #   headers: { "Accept" => "application/json",
      #     "User-Agent" => "IngredientInspector/1.0"})
      hold = data["ingredients"].map{|hash| hash["name"]}
      brand = data["brand"] || ''
      product = data["product"] || ''
      contact_array = data["manufacturer_contact"]
      if contact_array
        if contact_array == "Queued"
          contact_array = fetch_contact(data["domain"])
        end
        contact_array.each do |hash|
          if hash["typeId"] == "twitter"
            tweet = "@#{hash["username"]} #{product} contains #{hold.join(', ')} :("
            $twitter.update(tweet)
          elsif hash["typeId"] == "email"
            UserMailer.product_email(hash["address"], upc).deliver_now
          end
        end
      else
        tweet = "#{brand} #{product} contains #{hold.join(', ')} :("
        $twitter.update(tweet)
      end
      new_brand = Contacted.new(id: id, upc: upc, brand: brand, product: product)
      render json: [], :status => :ok
    else
      render json: [], :status => :failed_to_save
    end
  end

end

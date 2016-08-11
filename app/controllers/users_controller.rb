class UsersController < ApplicationController

  def login
    uid = params[:uid]
    provider = params[:provider]
    user = User.find_by(uid: uid, provider: provider)
    if user.empty?
      render json: [], :status => :bad_request
    else
      id = {id: user.id[0]}

      render json: id.as_json, :status => :ok
    end
  end

  def create
    uid = params[:uid]
    provider = params[:provider]
    @user = User.find_or_create_by_uid(uid: uid, provider: provider)
    id = { id: @user.id}
    render json: id.as_json
  end

  def index
    id = params[:id]
    @user = User.find_by(id: id)
    if @user
      data = {user: @user}
      render json: data.as_json
    else
      render json: [], :status => :no_user
    end
  end

  def approved
    upc = params[:upc]
    id = params[:id]
    @approved = Approved.new(id: id, upc: upc)
    if @approved.save
      @approveds = Approved.where(id: id)
      render json: @approveds.as_json, :status => :ok
    else
      render json: [], :status => :failed_to_save
    end
  end

  def avoid
    upc = params[:upc]
    id = params[:id]
    @avoid = Avoid.new(id: id, upc: upc)
    if @avoid.save
      @avoids = Avoid.where(id: id)
      render json: @avoids.as_json, :status => :ok
    else
      render json: [], :status => :failed_to_save
    end
  end

  def products
    id = params[:id]
    @brands = Product.find_by(id: id)
    render json: @brands.as_json
  end

  def contact_manufacturer #figure out how to receive selected ingredients. Body?
    upc = params[:upc]
    id = params[:id]
    data = Rails.cache.fetch("#{upc}/upc")
    # response = HTTParty.get("http://world.openfoodfacts.org/api/v9/product/#{upc}.json",
    #   headers: { "Accept" => "application/json",
    #     "User-Agent" => "IngredientInspector/1.0"})
    brand = data.manufacturer_contact
    new_brand = Product.new(id: id, upc: upc, brand: brand)
  end

end

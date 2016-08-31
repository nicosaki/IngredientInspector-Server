class UserMailer < ApplicationMailer
  default from: 'ingredientinspector@gmail.com'

  def product_email(address, upc)
    data = Rails.cache.fetch("#{upc}/upc")
    @ingredients = data.ingredients
    mail(to: address, subject: 'IngredientInspector: User Opinion')
  end
end

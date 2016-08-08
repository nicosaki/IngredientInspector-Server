class Ingredient < ActiveRecord::Base
  validates :name, presence: true
  validates :source, presence: true
end

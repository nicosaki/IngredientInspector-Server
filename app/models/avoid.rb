class Avoid < ActiveRecord::Base
  validates :uid, presence: true
  validates :upc, presence: true
end

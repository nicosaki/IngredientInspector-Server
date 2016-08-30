class Contacted < ActiveRecord::Base
  validates :upc, presence: true
  validates :uid, presence: true
end

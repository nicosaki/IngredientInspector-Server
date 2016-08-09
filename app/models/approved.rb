class Approved < ActiveRecord::Base
  validates :uid, presence: true
  validates :upc, presence: true
end

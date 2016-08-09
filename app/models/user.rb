class User < ActiveRecord::Base
  validates :uid, presence: true
  validates :provider, presence: true
  validates :name, presence: true
end

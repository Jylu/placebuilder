class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :transaction
  attr_accessible :message, :price
end

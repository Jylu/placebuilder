class Ad < ActiveRecord::Base
  attr_accessible :body, :link

  belongs_to :community
  has_one :image
end

class Ad < ActiveRecord::Base

  belongs_to :community
  has_one :image

  validates_presence_of :community

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add :community
  end

end

class Ad < ActiveRecord::Base

  belongs_to :community
  has_one :image

  validates_presence_of :community

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add :community
    t.add :community_id
    t.add :start_date
    t.add :end_date
    t.add :body
    t.add lambda {|u| u.image.image_url}, :as => :image_url
  end

end

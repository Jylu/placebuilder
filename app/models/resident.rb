class Resident < ActiveRecord::Base
  serialize :metadata, Hash

  belongs_to :community

  belongs_to :user

  def on_commonplace?
    self.user.present?
  end

  def friends_on_commonplace?
    [false, true].sample
  end
  
  def in_commonplace_organization?
    [false, true].sample
  end

  def have_dropped_flyers?
    [false, true].sample
  end

  def add_log(log)
    
  end

  def logs
    ["Bought a cow.", "Borrowed a babysitter.", "Hoed the lawn."]
  end

  def avatar_url
    begin
      User.find(self.user_id).avatar_url
    rescue
      "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    end
  end

end

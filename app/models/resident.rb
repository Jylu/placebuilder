class Resident < ActiveRecord::Base
  serialize :metadata, Hash
  serialize :logs, Array
  serialize :sector_tags, Array
  serialize :type_tags, Array  

  belongs_to :community

  belongs_to :user
  belongs_to :street_address

  has_many :flags

  def on_commonplace?
    self.user_id?
  end

  def street_address?
    self.street_address_id?
  end

  def friends_on_commonplace?
    [false, true].sample
  end
  
  def in_commonplace_organization?
    [false, true].sample
  end


  def add_log(date, text, tags)
    self.add_tags(tags)
    self.logs << [date, ": ", text].join
    self.save
  end

  def avatar_url
    begin
      self.user.avatar_url
    rescue
      "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    end
  end

  def tags
    tags = []
    tags += self.metadata[:tags] if self.metadata[:tags]
    tags << "registered" if self.user.present?
    tags << "email" if self.email?
    tags << "address" if self.address?
    tags
  end

  def add_tags(tag_or_tags)
    tags = Array(tag_or_tags)
    tags.each do |flag|
      self.flags.create(name: flag, next_flag: nil) 
    end
    self.metadata[:tags] ||= []
    self.metadata[:tags] |= tags
    self.community.add_resident_tags(tags)
    self.save
  end


  def add_sector_tags(tags)
    sectortags = tags.split(',')
    self.sector_tags ||= []
    self.sector_tags |= sectortags
    #self.community.add_resident_tags(tags)
    self.save
  end


  def add_type_tags(tag_or_tags)
    typetags = Array(tag_or_tags)
    self.type_tags ||= []
    self.type_tags |= typetags
    #self.community.add_resident_tags(tags)
    self.save
  end

  searchable do
    integer :community_id
    string :tags, :multiple => true
    string :sector_tags, :multiple => true
    string :type_tags, :multiple => true
    string :first_name
    string :last_name
  end

  # Correlates Resident with existing Users
  # and StreetAddresses [if possible]
  #
  # Since Users are always associated with a Resident,
  # this function simply adds tags to the existing
  # Resident file if a correlation exists and
  # does nothing otherwise, if given only an e-mail
  #
  # @return boolean, depending on whether a correlation was found or not
  # If true, destroy this [redundant] Resident file
  def correlate
    if self.address?
      matched_street = User.where("address ILIKE ? AND last_name ILIKE ?", self.address)

      if matched_street.count > 1
        matched = matched_street.select { |resident| resident.first_name == self.first_name }

        if matched.count > 1
          # Well, what are the odds? =(
        end

        if matched.count == 1
          # matched.first.add_tags(self.tags)
          return true
        else
          # No match, but should match with a StreetAddress file
          matched_addr = StreetAddress.where("address ILIKE ?","%#{self.address}%")

          if matched_addr.count == 1
            street = matched_addr.first
            if street.unreliable name == "#{self.first_name} #{self.last_name}"
              # add tags
              return true
            end

            # Not the property owner
            self.street_address = street
          end

          return false
        end
      end
    elsif self.email?
      matched_email = User.where("email ILIKE ? AND last_name ILIKE ?", self.email, self.last_name)

      if matched_email.count > 1
        # We have a problem; No two Users should have the same e-mail D=
      end

      # Add whatever was inputted to the existing Residents file
      if matched_email.count == 1
        # matched_email.first.add_tags(self.tags)
        return true
      else
        return false
      end
    else
      # A name isn't really much to work with.
      # Don't let this happen in a higher level function?

      # Until then, destroy as a contingency plan
      return true
    end
  end

end

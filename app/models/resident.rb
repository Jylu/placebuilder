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

  def manually_added?
    self.metadata[:manually_added] ||= false
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
=begin
    tags << "registered" if self.user.present?
    tags << "email" if self.email?
    tags << "address" if self.address?
=end
    tags
  end
  
  def manualtags
    self.flags.map &:name
  end
  
  def actionstags
    if self.on_commonplace?
      User.find(self.user_id).actions_tags
    else
      []
    end
  end

  # Created via Organizer App
  def manually_added
    todo = ["send nomination email"]
    self.metadata[:todos] ||= []
    self.metadata[:todos] |= todo
    self.community.add_resident_todos(todo)

    self.metadata[:manually_added] = true
  end

  def todos
    todos = []
    todos |= self.metadata[:todos] if self.metadata[:todos]
    todos
  end

  # Creates tags associated with the resident
  #
  # Returns a list of todos
  def add_flags(flags)
    add = []
    remove = []
    flags.each do |flag|
      if !self.flags.find_by_name(flag)
        f = self.flags.create(:name => flag)
        if rule = Flag.get_rule(f.name)
          remove |= rule[0]
          add |= rule[1]
        end
      end
    end

    [remove, add]
  end

  def add_tags(tag_or_tags)
    tags = Array(tag_or_tags)

    # Edit todo list
    self.metadata[:todos] ||= []
    todos ||= add_flags(tags)
    self.metadata[:todos] |= todos[1]
    self.metadata[:todos] -= todos[0]

    # Add to tag list
    self.metadata[:tags] ||= []
    self.metadata[:tags] |= tags
    self.community.add_resident_tags(tags)
    self.save
  end

  def remove_tag(tag)
    if flag = self.flags.find_by_name(tag)
      flag.destroy
    end
    tags = Array(tag)
    self.metadata[:tags] ||= []
    self.metadata[:tags] -= tags
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
    string :todos, :multiple => true
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

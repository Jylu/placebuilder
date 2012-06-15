class StreetAddress < ActiveRecord::Base
  serialize :metadata, Hash
  serialize :logs, Array

  belongs_to :community

  has_many :residents

  after_create :create_default_resident

  def have_dropped_flyers?
    [false, true].sample
  end

  def add_log(date, text, tags)
    self.add_tags(tags)
    self.logs << [date, ": ", text].join
    self.save
  end

  def tags
    tags = []
    tags << "address" if self.address?
    tags
  end

  # Creates a default Resident file so that it can be displayed in
  # the Organizer App.
  #
  # Note: It is possible to have two Resident files be the same person with
  # this function if a Resident[:name, :email] file of this person is inputted.
  # This should be resolved with a merge when the person registers as a user.
  def create_default_resident
    split_name = unreliable_name.to_s.split(" ")
    Resident.create(
      :first_name => split_name.shift.to_s.capitalize,
      :last_name => split_name.pop.to_s.capitalize,
      :address => self.address,
      :street_address => self)
  end

end

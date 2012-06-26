class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  # Creates rules for flags to follow
  def self.create_rule(from_flag, to_flag)
  end

  # Creates the "rule" for when this flag completes
  def create_chain(flag)
    self.next_flag = flag
  end

  # Checks if a rule exists for this flag
  # TODO Actually have a table of rules or something stored somewhere
  def check_chain_rules
    if self.name == "tested"
      create_chain("staged")
      self.save
      return [true, "not staged"]
    end
    if self.name == "staged"
      return [false, "not staged"]
    end
  end

end

class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  def self.get_rule(flag)
    @@rules[flag]
  end

  def self.get_rules
    @@rules ||= {}

    @@rules
  end

  # Creates rules for flags to follow
  def self.create_rule(from_flag, to_flag)
    @@rules ||= {}
    @@rules[from_flag] = to_flag
  end

  # Creates the "rule" for when this flag completes
  def create_chain(flag)
    self.next_flag = flag
  end

  # Checks if a rule exists for this flag
  # TODO Actually have a table of rules or something stored somewhere
  def check_chain_rules
    @@rules ||= {"tested"=>[nil, "not staged"], "staged"=>["not staged", nil]}
    if chain = @@rules[name]
      create_chain(chain[1])
      self.save
      return chain
    end
  end

end

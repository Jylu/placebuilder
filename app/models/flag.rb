class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  after_create :check_chain_rules

  # Creates the "rule" for when this flag completes
  def create_chain(flag)
    self.next_flag = flag
  end

  # Checks if a rule exists for this flag
  # TODO Actually have a table of rules or something stored somewhere
  def check_chain_rules
  end

end

class Flag < ActiveRecord::Base

  belongs_to :resident
  belongs_to :street_address

  # TODO Initialize with actual flags [load from text file or...?]
  def self.init
    {"tested"=>[nil, "not staged"], "staged"=>["not staged", nil]}
  end

  def self.get_rule(flag)
    @@rules[flag]
  end

  def self.get_rules
    @@rules ||= init

    @@rules
  end

  # Creates rules for flags to follow
  def self.create_rule(prev_flag, from_flag, to_flag)
    @@rules ||= init
    @@rules[from_flag] = [prev_flag, to_flag]
  end

  # Creates a chain of rules given a list of flags
  # The chain rules are stored in a hash of the form {from => [remove, add]}
  #
  # e.g. [a, b, c] => {a => [nil, b], b => [~b, c], c => [~c, nil]}
  def self.create_rules(flag_list)
    flags = Array(flag_list)
    start = flags.first
    last = flags.last

    if flags.count == 2
      create_rule(nil, start, "not "+last)
      create_rule("not "+last, last, nil)
    else

      # Create starting rule
      create_rule(nil, start, "not "+flags[1])

      # Create chain rules
      flags.each_with_index do |flag, i|
        next if flag == start || flag == last
        create_rule("not "+flag, flag, flags[i+1])
      end

      # Create terminal rule
      create_rule("not "+last, last, nil)
    end
  end

  # Checks if a rule exists for this flag
  # TODO Actually have a table of rules or something stored somewhere
  def check_chain_rules

    @@rules ||= init

    if chain = @@rules[name]

      return chain
    end
  end

end

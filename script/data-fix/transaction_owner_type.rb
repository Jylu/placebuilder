#!/usr/bin/env ruby

Transaction.all.each do |trans|
  if trans.community.nil?
    trans.community = Community.find(17)
    trans.owner_type = "User"
    trans.owner = User.find_by_email("cpdemo@demo.com")
    trans.save
    trans.destroy

    next
  end

  if trans.owner_type.nil?
    trans.owner_type = "User"
    trans.save
  end

  if trans.owner.nil?
    trans.owner = User.find_by_email("cpdemo@demo.com")
    trans.save
    trans.destroy
  end
end

#!/usr/bin/env ruby

# This is to retroactively add a Resident to old Users
# so that they may be displayed in the Organizer App

def retro_add(community)
  i = 0
  users = community.users.reject { |u| u.resident.present? }

  users.each do |u|
    i += 1
    if i % 10 == 0
      puts "Record ##{i}"
    end

    addr = u.address_correlate

    r = Resident.create(
      :community => community,
      :first_name => u.first_name,
      :last_name => u.last_name,
      :address => u.address,
      :email => u.email,
      :street_address => addr,
      :user => u,
      :community_id => community.id
    )
  end
end

puts "Watertown"
c = Community.find_by_name("Watertown")
retro_add(c)
puts ""

puts "Belmont"
c = Community.find_by_name("Belmont")
retro_add(c)
puts ""

puts "Lexington"
c = Community.find_by_name("Lexington")
retro_add(c)
puts ""

puts "Concord"
c = Community.find_by_name("Concord")
retro_add(c)
puts ""

#!/usr/bin/env ruby

# This is for adding tags that should've been added with
# import_new_community_maps.rb

def add(community, s)
  i = 0
  CSV.foreach(s, :headers => true) do |row|
    i += 1
    if i % 15 == 0
      puts "Record ##{i}"
    end
    h = row.to_hash

    first = h["Firstname"]
    last = h["Surname"]
    email = h["E-mail Address"]
    organizer = h["Organizer"]
    sector = h["Sector"]

    return if organizer.nil?

    first.strip!
    last.strip!
    organizer.strip!
    sector.capitalize! if !sector.nil?

    if email.nil?
      if last == "ORGANIZATION"
        r = community.residents.find_by_first_name(first)
      else
        r = community.residents.find_by_full_name("#{first} #{last}")
        if r.count > 1 && r.first.street_address.present?
          r = r[1]
        else
          r = r.first
        end
      end
    else
      r = community.residents.find_by_email(email)
    end

    r.add_tags("Organizer: #{organizer}")
    r.add_tags("Sector: #{sector}") if !sector.nil?
    tags = h["Tags"].split(', ')
    tags.each do |tag|
      r.add_tags(tag)
    end
  end
end

puts "Watertown"
c = Community.find_by_name("Watertown")
s = Rails.root.join("script", "data-fix", "WaterCommMap.csv")
add(c, s)
puts ""

puts "Belmont"
c = Community.find_by_name("Belmont")
s = Rails.root.join("script", "data-fix", "BelmontCommMap.csv")
add(c, s)
puts ""

puts "Lexington"
c = Community.find_by_name("Lexington")
s = Rails.root.join("script", "data-fix", "NewLexCommMap.csv")
add(c, s)
puts ""

puts "Concord"
c = Community.find_by_name("Concord")
s = Rails.root.join("script", "data-fix", "NewConCommMap.csv")
add(c, s)
puts ""

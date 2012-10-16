#!/usr/bin/env ruby

def port(community, s)
  i = 0
  CSV.foreach(s, :headers => true) do |row|
    i += 1
    if i % 100 == 0
      puts "Record ##{i}"
    end
    h = row.to_hash

    first = h["Firstname"]
    last = h["Surname"]
    organization = h["Organization"]
    email = h["E-mail Address"]
    pos = h["Position"]

    organizer = h["Organizer"]
    sector = h["Sector"]
    notes = h["Notes"]

    first.strip!
    last.strip!
    organizer.strip! if !organizer.nil?

    begin
      r = Resident.create(first_name: first,
                          last_name: last,
                          email: email,
                          organization: organization,
                          position: pos,
                          community: community,
                          sector_tag_list: sector,
                          organizer_list: organizer,
                          notes: notes,
                          manually_added: true)

      r.add_tags("Organizer: #{organizer}") if !organizer.nil?
      r.add_tags("Sector: #{sector}") if !sector.nil?
      tags = h["Tags"].split(', ')

      tags.each do |tag|
        r.add_tags(tag)
      end

      r.correlate
    rescue
      puts "Could not import line #{i}"
    end
  end
end

puts "Watertown"
c = Community.find_by_name("Watertown")
s = Rails.root.join("script", "data-fix", "WaterCommMap.csv")
port(c, s)
puts ""

puts "Belmont"
c = Community.find_by_name("Belmont")
s = Rails.root.join("script", "data-fix", "BelmontCommMap.csv")
port(c, s)
puts ""

puts "Lexington"
c = Community.find_by_name("Lexington")
s = Rails.root.join("script", "data-fix", "NewLexCommMap.csv")
port(c, s)
puts ""

puts "Concord"
c = Community.find_by_name("Concord")
s = Rails.root.join("script", "data-fix", "NewConCommMap.csv")
port(c, s)
puts ""

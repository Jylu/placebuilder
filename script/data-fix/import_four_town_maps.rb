#!/usr/bin/env ruby

def port(community, s)
  i = 0
  CSV.foreach(s, :headers => true) do |row|
    i += 1
    if i % 100 == 0
      puts "Record ##{i}"
    end
    h = row.to_hash

    first = h["First Name"]
    last = h["Last Name"]
    organization = h["Organization"]
    email = h["Email Address"]
    pos = h["Position"]

    type = h["Type"]
    sector = h["Sector"]
    notes = h["Notes"]

    if !first.nil?
      first.strip!
    else
      first = "First"
    end
    if !last.nil?
      last.strip!
    else
      last = "Last"
    end

    begin
      r = Resident.create(first_name: first,
                          last_name: last,
                          email: email,
                          organization: organization,
                          position: pos,
                          community: community,
                          sector_tag_list: sector,
                          notes: notes,
                          manually_added: true)

      r.add_tags("Type: #{type}") if !type.nil?
      r.add_tags("Sector: #{sector}") if !sector.nil?

      r.correlate
    rescue
      puts "Could not import line #{i}"
    end
  end
end

puts "Carlisle"
c = Community.find_by_name("Carlisle")
s = Rails.root.join("script", "data-fix", "CarlisleMap.csv")
port(c, s)
puts ""

puts "Sudbury"
c = Community.find_by_name("Sudbury")
s = Rails.root.join("script", "data-fix", "SudburyMap.csv")
port(c, s)
puts ""

puts "Somerville"
c = Community.find_by_name("Somerville")
s = Rails.root.join("script", "data-fix", "SomervilleMap.csv")
port(c, s)
puts ""

puts "Westwood"
c = Community.find_by_name("Westwood")
s = Rails.root.join("script", "data-fix", "WestwoodMap.csv")
port(c, s)
puts ""

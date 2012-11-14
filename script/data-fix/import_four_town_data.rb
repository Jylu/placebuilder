#!/usr/bin/env ruby

def port(community, s)

  i = 0
  CSV.foreach(s, :headers => true) do |row|
    i += 1
    if i % 500 == 0
      puts "Record ##{i}"
    end
    h = row.to_hash

    first = h["FirstName"].nil? ? nil : h["FirstName"].capitalize.strip
    last = h["LastName"].nil? ? nil : h["LastName"].capitalize.strip
    if !first.nil? && !first.empty? && !last.nil? && !last.empty?
      name = "#{first} #{last}"
    end
    street = h["ADDRESS"].squeeze(" ").strip
    zip = h["Zip"].to_i
    crrt = h["Crrt"]

    begin
      StreetAddress.create(address: street,
                           carrier_route: crrt,
                           zip_code: zip,
                           unreliable_name: name,
                           community: community)
    rescue
      puts "Could not import line #{i}"
    end
  end
end

puts "Carlisle"
c = Community.find_by_name("Carlisle")
if c.nil?
  c = Community.create(name: "Carlisle", slug: "Carlisle", state: "MA")
end
s = Rails.root.join("script", "data-fix", "CarlisleResidentFile.csv")
port(c, s)
puts ""

puts "Sudbury"
c = Community.find_by_name("Sudbury")
if c.nil?
  c = Community.create(name: "Sudbury", slug: "Sudbury", state: "MA")
end
s = Rails.root.join("script", "data-fix", "SudburyResidentFile.csv")
port(c, s)
puts ""

puts "Somerville"
c = Community.find_by_name("Somerville")
if c.nil?
  c = Community.create(name: "Somerville", slug: "Somerville", state: "MA")
end
s = Rails.root.join("script", "data-fix", "SomervilleResidentFile.csv")
port(c, s)
puts ""

puts "Westwood"
c = Community.find_by_name("Westwood")
if c.nil?
  c = Community.create(name: "Westwood", slug: "Westwood", state: "MA")
end
s = Rails.root.join("script", "data-fix", "WestwoodResidentFile.csv")
port(c, s)
puts ""

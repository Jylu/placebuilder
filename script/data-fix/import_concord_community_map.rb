class ImportConcordCommunityMap < ActiveRecord::Base

  community = Community.find_by_name("Concord")
  s = Rails.root.join("script", "data-fix", "ConcordCommunityMap.csv")
  i = 0
  CSV.foreach(s, :headers => true) do |row|
    i += 1
    if i % 100 == 0
      puts "Record ##{i}"
    end
    h = row.to_hash

    first = h["Firstname"]
    last = h["Surname"]
    organization = h["Company"]
    email = h["E-mail Address"]
    pos = h["Position"]
    type_tag = h["Type"]
    type = type_tag.split("Type: ").first
    sector_tag = h["Sector"]
    sector = sector_tag.split("Sector: ").first
    notes = h["Notes"]
    tag = h["Email Tag"]
    organizer_tag = h["Organizer"]
    organizer = organizer_tag.split("Organizer: ").first
  end
end

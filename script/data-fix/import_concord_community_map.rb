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
    notes = h["Notes"]

    type_tag = h["Type"]
    sector_tag = h["Sector"]
    tag = h["Tag"]
    organizer_tag = h["Organizer"]

    type = type_tag.split("Type: ").first if !type_tag.nil?
    sector = sector_tag.split("Sector: ").first if !sector_tag.nil?
    organizer = organizer_tag.split("Organizer: ").first if !organizer_tag.nil?

    first.strip!
    last.strip!
    organizer.strip!

    begin
      r = Resident.create(first_name: first,
                          last_name: last,
                          email: email,
                          organization: organization,
                          position: pos,
                          community: community,
                          sector_tag_list: sector,
                          organizer_list: organizer,
                          type_tag_list: type,
                          notes: notes,
                          manually_added: true)

      r.add_tags(type_tag) if !type_tag.nil?
      r.add_tags(tag)
      r.add_tags(sector_tag)
      r.add_tags(organizer_tag)
      r.correlate
    rescue
      puts "Could not import line #{i}"
    end
  end
end

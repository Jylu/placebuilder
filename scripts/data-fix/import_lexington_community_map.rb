class ImportLexingtonCommunityMap < ActiveRecord::Base

  community = Community.find_by_name("Lexington")
  s = Rails.root.join("scripts", "data-fix", "LexCommunityMap.csv")
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
    phone = h["Phone"]

    organizer = h["Organizer"]
    type = h["Type"]
    sector = h["Sector"]
    tag = h["Email Tag"]
    notes = h["Notes"]
    type_tag = "Type: " << type if !type.nil?


    first.strip!
    last.strip!
    organizer.strip!

    begin
      r = Resident.create(first_name: first,
                          last_name: last,
                          email: email,
                          phone: phone,
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
      r.correlate
    rescue
      puts "Could not import line #{i}"
    end
  end
end

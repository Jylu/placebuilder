class ImportLexingtonCommunityMap < ActiveRecord::Base

  community = Community.find_by_name("Lexington")
  s = Rails.root.join("scripts", "data-fix", "LexCommunityMap.csv")
  CSV.foreach(s, :headers => true) do |row|
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

    r = Resident.create(first_name: first,
                        last_name: last,
                        email: email,
                        phone: phone,
                        organization: organization,
                        position: pos,
                        community: community,
                        sector_tag_list: sector,
                        organizer_list: organizer,
                        input_method_list: type,
                        notes: notes,
                        manually_added: true)

    r.add_tags(tag)
    r.add_tags("Community Map")
  end
end

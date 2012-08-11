class ImportLexingtonData < ActiveRecord::Base

  community = Community.find_by_name("Lexington")
    s = Rails.root.join("scripts", "data-fix", "LexMelissadata.csv")
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

      begin
        StreetAddress.create(address: street,
                           carrier_route: h["Crrt"],
                           zip_code: zip,
                           unreliable_name: name,
                           community: community)
      rescue
        puts "Could not import line #{i}"
      end
    end
end

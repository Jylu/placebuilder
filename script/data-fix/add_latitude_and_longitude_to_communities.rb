#!/usr/bin/env ruby
Community.all.each do |community|
  begin
    zip_code = community.zip_code
    next unless zip_code.present?
    coordinates = Geocoder.search(zip_code)[0].coordinates
    community.update_attributes(
      latitude: coordinates[0],
      longitude: coordinates[1]
    )
    sleep 2
  rescue
    puts "Could not geocode #{community.slug}"
  end
end

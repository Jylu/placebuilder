#!/usr/bin/env ruby
ZIP_CODES = {
  "Warwick" => "10990",
  "Fayetteville" => "72701",
  "Raleigh" => "27601",
  "StPaul" => "55112",
  "Farragut" => "37934",
  "Marquette" => "49855",
  "concord" => "01742"
}

ZIP_CODES.each do |slug, zip_code|
  begin
    Community.where(slug: slug).first.update_attributes(zip_code: zip_code)
  rescue
    puts "Could not find community '#{slug}'"
  end
end

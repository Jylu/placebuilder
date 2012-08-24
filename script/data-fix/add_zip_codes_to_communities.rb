#!/usr/bin/env ruby
ZIP_CODES = {
  "Warwick" => "10990",
  "Fayetteville" => "72701",
  "Raleigh" => "27601",
  "StPaul" => "55112",
  "Farragut" => "37934",
  "Marquette" => "49855",
  "Concord" => "01742",
  "Lexington" => "02421",
  "Cambridge" => "02141",
  "HarvardNeighbors" => "02138"
}

ZIP_CODES.each do |slug, zip_code|
  begin
    Community.where(slug: slug).first.update_attributes(zip_code: zip_code)
  rescue
    puts "Could not find community '#{slug}'"
  end
end

begin
  community = Community.where(slug: "Kincardine").first
  community.should_delete = true
  community.destroy
end

#!/usr/bin/env ruby

COMMUNITY_SLUGS = {
  "Warwick" => "NY",
  "GraduateCommons" => "MA",
  "Akron" => "OH",
  "Lexington" => "MA"
}

COMMUNITY_SLUGS.each do |slug, state|
  community = Community.where(slug: slug).first
  community.update_attribute(:state, state)
  community.save!
end

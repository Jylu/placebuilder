#!/usr/bin/env ruby

COMMUNITY_SLUGS = [
  "Kincardine",
  "upperuws"
]

COMMUNITY_SLUGS.each do |slug|
  community = Community.where(slug: slug).first
  community.should_delete = treu
  community.destroy
end

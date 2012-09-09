#!/usr/bin/env ruby

COMMUNITY_SLUGS = %w[
  Kincardine
  upperuws
  Hinkely
  GreenwoodLake
  sega
  StPaul
  Farragut
  CommonPlace
  umw
  Cambridge
]

COMMUNITY_SLUGS.each do |slug|
  begin
    community = Community.where(slug: slug).first
    community.should_delete = true
    community.destroy
  rescue; end
end

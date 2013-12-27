#!/usr/bin/env ruby

GroupPost.all.each do |g|
  group = Group.find(g.group_id)
  g.groups += [group]
  g.save
end

#!/usr/bin/env ruby

# This is to set the guest flag on the guest account to true
# to enable the publically viewable site to all communities

u = User.find_by_email("guestguest@gmail.com")
u.guest = true
u.save
puts "Finished"

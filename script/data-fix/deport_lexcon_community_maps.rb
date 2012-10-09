#!/usr/bin/env ruby

def deport(c, s)
  i = 0
  mult = []
  u = []

  CSV.foreach(s, :headers => true) do |row|
    i += 1
    if i % 100 == 0
      puts "Record ##{i}"
    end
    h = row.to_hash

    email = h["E-mail Address"]
    if email.nil?
      first = h["Firstname"]
      last = h["Surname"]
      full = "#{first} #{last}"

      residents = c.residents.find_by_full_name(full)
    else
      residents = c.residents.find_all_by_email(email)
    end

    count = residents.count

    next if count == 0
    if count > 1
      mult << residents.first
      next
    else
      r = residents.first
      if r.user.present?
        r.metadata[:tags] = []
        u << r
        next
      else
        r.destroy
      end
    end
  end

  puts "Has multiple files: "
  mult.each do |m|
    puts "#{m.name}: #{m.email}"
  end
  puts ""

  puts "Has User: "
  u.each do |j|
    puts "#{j.name}: #{j.email}"
  end
  puts ""
end

puts "Lexington"
c = Community.find_by_name("Lexington")
s = Rails.root.join("script", "data-fix", "LexCommunityMap.csv")
deport(c, s)

puts "Concord"
c = Community.find_by_name("Concord")
s =  Rails.root.join("script", "data-fix", "ConcordCommunityMap.csv")
deport(c, s)

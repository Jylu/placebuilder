class RemoveDuplicateResidents < ActiveRecord::Base

  community = Community.find_by_name("Lexington")
  residents = community.residents.all

  i = 0
  residents.each do |r|
    i += 1
    if i % 500 == 0
      puts "Record ##{i}"
    end
    clones = community.residents.find_by_full_name(r.full_name)

    next if clones.length <= 1

    clones.each do |c|
      next if !c.user.nil?
      next if !c.street_address.nil?

      c.destroy
    end
  end
end

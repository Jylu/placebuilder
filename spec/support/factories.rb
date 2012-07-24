FactoryGirl.define do
  factory :community do |f|
    f.name { Forgery(:address).city }
    f.slug { Forgery(:address).city.downcase }
    f.time_zone { "Eastern Time (US & Canada)" }
    f.zip_code { "02132" }
  end

  factory :neighborhood do |f|
    f.name { Forgery(:address).street_name }
    f.bounds [[0,0],[0,0]]
    f.latitude 0.0
    f.longitude 0.0
    f.association :community
  end


  factory :user do |f|
    f.association :neighborhood
    f.association :community
    f.first_name { Forgery(:name).first_name }
    f.last_name { Forgery(:name).last_name }
    f.email {|u| "#{u.first_name}.#{u.last_name}@example.com".downcase }
    f.address "123 any lane"
    f.password { Forgery(:basic).password }
  end

  factory :post do |f|
    f.body { Forgery(:lorem_ipsum).paragraphs(1) }
    f.association :user
  end

  factory :event do |f|
    f.name { Forgery(:lorem_ipsum).words(2) }
    f.description { Forgery(:lorem_ipsum).paragraph }
    f.date { Time.now + rand(6).week }
    f.start_time { Time.parse("#{rand(24)}:#{rand(60)}") }
    f.association :owner
  end

  factory :announcement do |f|
    f.subject { Forgery(:lorem_ipsum).words(2) }
    f.body { Forgery(:lorem_ipsum).paragraph }
    f.association :feed
  end

  factory :feed do |f|
    f.name { Forgery(:name).company_name }
    f.about { Forgery(:basic).text }
  end

  factory :message do |f|
    f.association :user
    f.association :recipient, :factory => :user
    f.subject { Forgery(:lorem_ipsum).words(2) }
    f.body { Forgery(:lorem_ipsum).sentence }
  end

  factory :referral do |f|
    f.association :event
    f.association :referee, :factory => :user
    f.association :referrer, :factory => :user
  end

  factory :resident do
    community
    sequence(:first_name) { |n| "Resident#{n}" }
    last_name "Doe"
    email { "#{first_name}@example.com" }
  end
end

#  the lat/lon of this address is (45.5207, -122.6628)
FactoryGirl.define do
  factory :location do
    name 'Test Location Name'
    street '303 Southeast 3rd Avenue'
    city 'Portland'
    state 'OR'
    zip '97214'
    association :region, :name => 'portland'
    association :location_type
  end

  factory :machine do
    name 'Test Machine Name'
  end

  factory :location_machine_xref do
    association :location
    association :machine
  end

  factory :location_type do
    name 'Test Location Type'
  end

  factory :zone do
    name 'Test Zone'
  end

  factory :operator do
    name 'Test Operator'
  end

  factory :region do
    name 'Test Region'
  end

  factory :machine_score_xref do
    association :location_machine_xref
    association :user
  end

  factory :event do
    name 'Test Event'
  end

  factory :user do
    initials 'cap'
    sequence(:email) {|n| "captainamerica#{n}@foo.bar"}
    password 'password'
    association :region, :name => 'portland'
  end

  factory :location_picture_xref do
    association :location
    association :user
    photo File.open(File.join(Rails.root, '/public/images/favicon.ico'))
  end

  factory :region_link_xref do 
    name 'Test Link Name'
    description 'This is a test link'
    url 'http://www.foo.com'
    category 'Test Category'
    association :region
  end
end


Factory.define :user do |user|
  user.first_name "test"
  user.last_name  "user"
  user.username   "test"
  user.password   "foobar"
  user.email      "test@example.com"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :username do |n|
  "test#{n}"
end

Factory.define :site do |site|
  site.name  "Test Site"
  site.state "CA"
end

Factory.sequence :site_name do |n|
  "Test Site #{n}"
end

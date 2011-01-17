
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

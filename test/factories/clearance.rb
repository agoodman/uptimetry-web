Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.first_name             { 'first' }
  user.last_name              { 'last' }
  user.email                 { Factory.next :email }
  user.password              { "password" }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email_confirmed { true }
end

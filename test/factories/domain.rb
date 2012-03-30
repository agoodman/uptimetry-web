Factory.sequence :domain_name do |n| 
  "name##{n}"
end

Factory.define :domain do |domain|
  domain.name { Factory.next :domain_name }
end

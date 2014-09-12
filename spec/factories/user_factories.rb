FactoryGirl.define do
  
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    email { |u| "#{u.username}@example.com" }
    password "my_secret_password"
  end
  
end
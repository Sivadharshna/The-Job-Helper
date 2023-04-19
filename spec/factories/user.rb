FactoryGirl.define do
    factory :user do
       email 'user@example.com'
       password 'password' 
       role 'company'
    end
end
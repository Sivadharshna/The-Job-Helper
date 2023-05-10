FactoryGirl.define do

    factory :accepted_offer do
        approval_type 'IndividudalApplication'
        approval_id 2 
        schedule Time.now+360.day
    end
end

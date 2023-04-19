FactoryGirl.define do

    factory :accepted_offer do
        schedule Time.now+1.day
        individual_application  
    end
end

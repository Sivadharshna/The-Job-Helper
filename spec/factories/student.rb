FactoryGirl.define do
    factory :student do
        course
        name 'Sivadharshna M'
        sslc_percentage 91.1
        hsc_diplomo 'Hsc'
        hsc_diplomo_percentage 85.5
        cgpa 9.1
        graduation_year 2024
        placement_status nil
    end
end

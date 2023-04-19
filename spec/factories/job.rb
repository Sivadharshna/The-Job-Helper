FactoryGirl.define do
    
    factory :job do
        company
        name 'Junior Software Developer'
        description 'requires practical knowledge'
        salary 7.5
        minimum_experience 0
        mode 'physical'
        minimum_educational_qualification 'Bachelor of Engineering'
        expected_sslc_percentage 94.6
        expected_hsc_percentage 87.5
        expected_cgpa 7.6
    end

end
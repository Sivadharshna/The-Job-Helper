FactoryGirl.define do
	factory :doorkeeper_application, class: 'Doorkeeper::Application' do
        name "Web client"
        redirect_uri ""
        scopes ""
    end 
end
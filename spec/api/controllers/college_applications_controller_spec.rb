require 'rails_helper'

RSpec.describe Api::V1::CollegeApplicationsController, type: :request do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}
    
        describe 'GET #index' do
            context 'check user access' do
        
                it "college can view applications" do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)                
                    get '/api/v1/colleges/'+college.id.to_s+'/college_applications' , params: {access_token: user2_token.token}
                    expect(response).to have_http_status(200)               
                end 
                it 'restricts access when individual tries to view the college show' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)     
                    get '/api/v1/colleges/'+college.id.to_s+'/college_applications', params: {access_token: user3_token.token}
                    expect(response).to have_http_status(403)     
                end
                it 'when a company access the show, it is rendered status 200' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)     
                    get '/api/v1/companies/'+company.id.to_s+'/college_applications'  , params: {access_token: user1_token.token} 
                    expect(response).to have_http_status(200)
                end                
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                #let(:college) { build(:college, user: nil, name: 'Info institute of technology', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create an application when the current user's role is college" do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1) 
                    post '/api/v1/companies/'+company.id.to_s+'/college_applications/new' , params: { college: college.attributes ,access_token: user2_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'an individual cannot create a college application' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1) 
                    post '/api/v1/companies/'+company.id.to_s+'/college_applications/new', params: { college: college.attributes , access_token: user3_token.token}
                    expect(response).to have_http_status(403)
                end
                it 'a company cannot create a college application' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1) 
                    post '/api/v1/companies/'+company.id.to_s+'/college_applications/new', params: { college: college.attributes , access_token: user1_token.token}
                    expect(response).to have_http_status(403)
                end
            end
        end       

end 
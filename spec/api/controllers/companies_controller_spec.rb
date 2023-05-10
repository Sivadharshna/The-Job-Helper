require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :request do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}
    
    
    
        describe "GET api/companies #index" do
            context 'check user access' do
                it "restricts access when company tries to view index" do
                    get '/api/v1/companies', params: { access_token: user1_token.token, format: :json }
                    expect(response).to have_http_status(403)
                end 
                it 'restricts access when individual tries to view the company index' do
                    get '/api/v1/companies', params: { access_token: user3_token.token, format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'when a college access the index, it is rendered status 200' do
                    get '/api/v1/companies', params: { access_token: user2_token.token, format: :json }
                    expect(response).to have_http_status(200)
                end
            end
        end
    
        describe 'GET #show' do
            context 'check user access' do
                let!(:company) { create(:company, user: user1)}
                it 'allows any valid user to see the show template' do
                    get '/api/v1/companies/'+company.id.to_s, params: { access_token: user2_token.token, format: :json }
                    expect(response).to have_http_status(200)
                end
                it 'does not allow a user without access to view the details' do
                    get '/api/v1/companies/'+company.id.to_s
                    expect(response).to have_http_status(401)
                end
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                let(:company) { build(:company, user: nil, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create a company when the current user's role is company" do
                    post '/api/v1/companies' , params: { access_token: user1_token.token, company: company.attributes, format: :json }
                    expect(response).to have_http_status(200)
                end
                it 'an individual cannot create a company' do
                    post '/api/v1/companies', params: { access_token: user3_token.token, company: company.attributes ,format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot create a company' do
                    post '/api/v1/companies', params: { access_token: user2_token.token, company: company.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end
            end
        end       

        describe 'PUT #update' do
            context 'check user access' do
                let(:company) { create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can update a company when the current user's role is company" do
                    put '/api/v1/companies/'+company.id.to_s , params: { access_token: user2_token.token, company: company.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'an individual cannot create a company' do
                    put '/api/v1/companies/'+company.id.to_s , params: { access_token: user2_token.token, company: company.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot create a company' do
                    put '/api/v1/companies/'+company.id.to_s , params: { access_token: user2_token.token, company: company.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end 
            end
        end

        
        
end
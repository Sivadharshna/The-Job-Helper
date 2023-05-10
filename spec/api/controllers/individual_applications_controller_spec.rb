require 'rails_helper'

RSpec.describe Api::V1::IndividualApplicationsController, type: :request do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}

    describe 'GET #index' do
        context 'check user access' do
            it 'a company can view the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                get '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s+'/individual_applications' , params: {  access_token: user1_token.token }
                expect(response).to have_http_status(200)
            end
            it 'an individual can view the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                get '/api/v1/individual/'+individual.id.to_s+'/individual_applications', params: {  access_token: user3_token.token }
                expect(response).to have_http_status(200)
            end
            it 'a college cannot view the individual application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                get '/api/v1/individual/'+individual.id.to_s+'/individual_applications', params: {  access_token: user2_token.token}
                expect(response).to have_http_status(403)
            end
        end
    end

    describe 'POST #create' do
        context 'check user access' do
            it 'a company cannot create the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                post '/api/v1/jobs/'+job.id.to_s+'/individual_applications', params: {  individual_application: application.attributes, access_token: user1_token.token}
                expect(response).to have_http_status(403)
            end
            it 'an individual can create the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=build(:individual_application, individual: individual, job: job)
                post '/api/v1/jobs/'+job.id.to_s+'/individual_applications', params: { individual_application: application.attributes, access_token: user3_token.token}
                expect(response).to have_http_status(200)
            end
            it 'a college cannot create the individual application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                post '/api/v1/jobs/'+job.id.to_s+'/individual_applications', params: { individual_application: application.attributes, access_token: user2_token.token}
                expect(response).to have_http_status(403)
            end
        end
    end

end
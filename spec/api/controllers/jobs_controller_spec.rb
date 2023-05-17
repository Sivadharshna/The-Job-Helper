require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :request do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }
    
        describe "GET #index" do
            context 'check user access' do
                let!(:company) { create(:company, user: user1) }
                let!(:job) { create(:job , company: company) }
                it "when a company access the index, it is rendered with the index" do
                    get '/api/v1/companies/'+company.id.to_s+'/jobs', params: {access_token: user1_token.token}
                    expect(response).to have_http_status(403)
                end
                it 'when a individual access the index, it is rendered with the index' do
                    get '/api/v1/companies/'+company.id.to_s+'/jobs', params: {access_token: user3_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'denies when college tries to view the index' do
                    get '/api/v1/companies/'+company.id.to_s+'/jobs', params: {access_token: user2_token.token}
                    expect(response).to have_http_status(403)
                end
            end
        end

        describe "GET #specific" do
            context 'check user access' do
                let!(:company) { create(:company, user: user1) }
                let!(:job) { create(:job , company: company) }
                
                it "when a individual access the specific, it is rendered with the index" do
                    get '/api/v1/jobs/specific', params: {access_token: user1_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'when a individual access the specific, it is rendered with the index' do
                    individual= create(:individual, user: user3)
                    get '/api/v1/jobs/specific', params: {access_token: user3_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'denies when college tries to view the specifc' do
                    get '/api/v1/jobs/specific', params: {access_token: user2_token.token}
                    expect(response).to have_http_status(403)
                end
            end
        end
    
        describe 'GET #show' do
            context 'check user access' do
                let!(:company) { create(:company, user: user1)}
                let!(:job) { create(:job , company: company) }
                it 'allows individual to see the show template' do
                    get '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s, params: {id: company.id, access_token: user3_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'allow company to see the show template' do
                    get '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s, params: {id: company.id, access_token: user1_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'does not allow college to see the show template' do
                    get '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s, params: {id: company.id, access_token: user2_token.token}
                    expect(response).to have_http_status(403)
                end
            end
        end

        describe "POST #create" do
            context 'check user access' do
                let(:company) { create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                let!(:job) { create(:job , company: company) }
                it "can create a job when the current user's role is company" do
                    post '/api/v1/companies/'+company.id.to_s+'/jobs', params: { job: job.attributes , access_token: user1_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'an individual cannot create a job' do
                    post '/api/v1/companies/'+company.id.to_s+'/jobs', params: { job: job.attributes ,access_token: user3_token.token}
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot create a job' do
                    post '/api/v1/companies/'+company.id.to_s+'/jobs', params: { job: job.attributes, access_token: user2_token.token}
                    expect(response).to have_http_status(403)
                end
            end
        end

        describe 'PUT #update' do
            context 'check user access' do
                let(:company) { create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                let!(:job) { create(:job , company: company) }
                it "can update a job when the current user's role is company" do
                    put '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s , params: { id: company.id, job: { name: 'Associate software developer' } ,access_token: user1_token.token }
                    expect(response).to have_http_status(200)
                    job.reload
                    expect(job.name).to eq('Associate software developer')
                end
                it 'an individual cannot update a job' do
                    put '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s , params: { id: company.id, job: { name: 'Associate software developer' }, access_token: user3_token.token }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot update a job' do
                    put '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s , params: { id: company.id, company: { name: 'Associate software developer' } , access_token: user2_token.token}
                    expect(response).to have_http_status(403)
                end
            end
        end

end
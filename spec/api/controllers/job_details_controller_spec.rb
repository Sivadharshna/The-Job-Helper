require 'rails_helper'

RSpec.describe Api::V1::JobDetailsController, type: :request do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }
    
        describe 'GET #index' do
            context 'check user access' do
                it "college cannot view job details" do    
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                    
                    get '/api/v1/individuals/'+individual.id.to_s+'/job_details' , params: {access_token: user2_token.token}
                    expect(response).to have_http_status(403)         
                end 
                it 'individuals can view job details' do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                    
                    get '/api/v1/individuals/'+individual.id.to_s+'/job_details', params: {access_token: user3_token.token}
                    expect(response).to have_http_status(200)
                end
                it 'companies cannot view job details' do 
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                    
                    get '/api/v1/individuals/'+individual.id.to_s+'/job_details', params: {access_token: user1_token.token}   
                    expect(response).to have_http_status(403)
                end                
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                it "college cannot create job details" do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                                        
                    job_selected=build(:job_detail, accepted_offer: accepted_offer)            
                    post '/api/v1/accepted_offers/'+accepted_offer.id.to_s+'/job_details', params: { job_detail: job_selected.attributes ,access_token: user2_token.token}
                    expect(response).to have_http_status(403)            
                end 
                it 'individuals cannot create job details' do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id) 
                    job_selected=build(:job_detail, accepted_offer: accepted_offer)                     
                    post '/api/v1/accepted_offers/'+accepted_offer.id.to_s+'/job_details', params: {job_detail: job_selected.attributes ,access_token: user3_token.token }
                    expect(response).to have_http_status(403)
                end
                it 'companies can create job details' do    
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)  
                    job_selected=build(:job_detail, accepted_offer: accepted_offer)                    
                    post '/api/v1/accepted_offers/'+accepted_offer.id.to_s+'/job_details', params: { job_detail: job_selected.attributes , access_token: user1_token.token } 
                    expect(response).to have_http_status(200)
                end       
            end
        end       

end 
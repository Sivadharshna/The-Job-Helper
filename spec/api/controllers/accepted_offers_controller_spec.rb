require 'rails_helper'

RSpec.describe Api::V1::AcceptedOffersController, type: :request do

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
        
                it "college can view accepted_offers" do
                    company=create(:company, user: user1)
                    college=create(:college, user: user2)
                    @college_application=create(:college_application, college: college, company: company)
                    accepted_colleges=create(:accepted_offer,  approval_type: 'CollegeApplication', approval_id: @college_application.id)                
                    get '/api/v1/colleges/'+college.id.to_s+'/accepted_offers/'+accepted_colleges.id.to_s, params: {access_token: user2_token.token, format: :json}
                    expect(response).to have_http_status(200)               
                end 
                it 'individuals can view accepted offers' do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    @individual_application=create(:individual_application, individual: individual, job: job)
                    @accepted_individuals=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: @individual_application.id)
                    get '/api/v1/individuals/'+individual.id.to_s+'/accepted_offers/'+@accepted_individuals.id.to_s, params: {access_token: user3_token.token, format: :json}
                    expect(response).to have_http_status(200)
                end
                it 'companies can view accepted offers' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)   
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    college_application=create(:college_application, college: college, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)  
                    accepted_colleges=create(:accepted_offer,  approval_type: 'CollegeApplication', approval_id: college_application.id)                
                    get '/api/v1/companies/'+company.id.to_s+'/accepted_offers/'+accepted_colleges.id.to_s, params: {access_token: user1_token.token, format: :json, id: accepted_individuals.id} 
                    expect(response).to have_http_status(200)
                end                
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                it "individual cannot create accepted_offers" do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=build(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)              
                    post '/api/v1/companies/'+company.id.to_s+'/jobs/'+job.id.to_s+'/individual_applications/'+individual_application.id.to_s+'/accepted_offers/new' , params: { accepted_offers: accepted_individuals.attributes,  access_token: user3_token.token, format: :json} 
                    expect(response).to have_http_status(403)            
                end 
                it 'colleges cannot create accepted offers' do
                    company=create(:company, user: user1)
                    college=create(:college, user: user2)
                    college_application=create(:college_application, college: college, company: company)
                    accepted_colleges=create(:accepted_offer,  approval_type: 'CollegeApplication', approval_id: college_application.id)                
                    college_application=create(:college_application, college:  college, company: company)
                    accepted_colleges=build(:accepted_offer, approval_type: 'CollegeApplication', approval_id: college_application.id)
                    post '/api/v1/companies/'+company.id.to_s+'/college_applications/'+college_application.id.to_s+'/accepted_offers/new' , params: {  accepted_offers: accepted_colleges.attributes , access_token: user2_token.token, format: :json}
                    expect(response).to have_http_status(403)
                end
                it 'companies can create accepted offers' do
                    company=create(:company, user: user1)   
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=build(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)  
                    post '/api/v1/companies/'+company.id.to_s+'/individual_applications/'+individual_application.id.to_s+'/accepted_offers/new' , params: { accepted_offer: accepted_individuals.attributes,  access_token: user1_token.token, format: :json } 
                    expect(response).to have_http_status(200)
                end       
            end
        end       

end 
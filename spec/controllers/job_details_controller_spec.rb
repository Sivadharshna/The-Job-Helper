require 'rails_helper'

RSpec.describe JobDetailsController, type: :controller do

    let!(:user2) { create(:user, role: 'college') }
    let!(:user1) { create(:user,email: 'company@example.com', role: 'company') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}


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
                    sign_in user2
                    get :index, params: {individual_id: individual.id}
                    expect(flash[:notice]).to eq('Restricted Access')         
                end 
                it 'individuals can view job details' do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                    
                    sign_in user3
                    get :index, params: {individual_id: individual.id}
                    expect(response).to render_template(:index)
                end
                it 'companies cannot view job details' do 
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_offer=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                    
                    sign_in user1
                    get :index, params: {individual_id: individual.id}   
                    expect(response).to redirect_to(root_path)
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
                    accepted_individuals=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)                         
                    sign_in user2
                    post :create, params: { accepted_offer_id: accepted_individuals.id }
                    expect(flash[:notice]).to eq('Restricted Access')             
                end 
                it 'individuals cannot create job details' do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)    
                    sign_in user3
                    post :create, params: { accepted_offer_id: accepted_individuals.id }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'companies can create job details' do  
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)      
                    sign_in user1
                    post :create, params: { accepted_offer_id: accepted_individuals.id } 
                    expect(flash[:notice]).to eq('Selected successfully')
                end       
            end
        end       

end 
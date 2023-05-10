require 'rails_helper'

RSpec.describe AcceptedOffersController, type: :controller do

    let!(:user2) { create(:user, role: 'college') }
    let!(:user1) { create(:user,email: 'company@example.com', role: 'company') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}
 
    
        describe 'GET #index' do
            context 'check user access' do
        
                it "college can view accepted_offers" do
                    company=create(:company, user: user1)
                    college=create(:college, user: user2)
                    @college_application=create(:college_application, college: college, company: company)
                    accepted_colleges=create(:accepted_offer,  approval_type: 'CollegeApplication', approval_id: @college_application.id)                                
                    sign_in user2
                    get :index, params: {college_id: college.id}
                    expect(response).to render_template(:index)               
                end 
                it 'individuals can view accepted offers' do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    @individual_application=create(:individual_application, individual: individual, job: job)
                    @accepted_individuals=create(:accepted_offer, approval_type: 'IndividualApplication', approval_id: @individual_application.id)
                    sign_in user3
                    get :index, params: {individual_id: individual.id}
                    expect(response).to render_template(:index)
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
                    sign_in user1
                    get :index , params: {company_id: company.id}  
                    expect(response).to render_template(:index)
                end                
            end
        end

=begin
        describe "POST #create" do 
            context 'check user access' do
                it "college cannot create accepted_offers" do
                    company= create(:company, user: user1)
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=build(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)              
                    sign_in user2
                    post '/companies/'+company.id.to_s+'/individual_applications/'+individual_application.id.to_s+'/accepted_offers/new', params: { schedule: accepted_individuals.schedule}
                    #post :create, params: { accepted_offers: accepted_individuals.attributes ,company_id:  company.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end 
                it 'individuals cannot create accepted offers' do
                    company=create(:company, user: user1)
                    college=create(:college, user: user2)
                    college_application=create(:college_application, college: college, company: company)
                    #accepted_colleges=create(:accepted_offer,  approval_type: 'CollegeApplication', approval_id: college_application.id)                
                    college_application=create(:college_application, college:  college, company: company)
                    accepted_colleges=build(:accepted_offer, approval_type: 'CollegeApplication', approval_id: college_application.id)
                    #post :create, params: { accepted_offers: accepted_colleges.attributes, company_id:  company.id}
                    post '/companies/'+company.id.to_s+'/college_applications/'+college_application.id.to_s+'/accepted_offers/new', params: {accepted_offer: accepted_colleges.attributes}
                    expect(flash[:notice]).to eq('Restricted Access')  #, approval_type: 'CollegeApplications', approval_id: college_application.id 
                    expect(response).to redirect_to(root_path)
                end
                it 'companies can create accepted offers' do
                    company=create(:company, user: user1)   
                    individual=create(:individual, user: user3)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, individual: individual, job: job)
                    accepted_individuals=build(:accepted_offer, approval_type: 'IndividualApplication', approval_id: individual_application.id)       
                    sign_in user1
                    post :create, params: { accepted_offers: accepted_individuals.attributes , company_id:  company.id } 
                    expect(flash[:notice]).to eq('Saved Sucessfully!')     
                end       
            end
        end  
=end     

end 
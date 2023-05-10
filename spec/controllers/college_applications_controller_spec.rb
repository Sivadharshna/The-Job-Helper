require 'rails_helper'

RSpec.describe CollegeApplicationsController, type: :controller do

    let!(:user2) { create(:user, role: 'college') }
    let!(:user1) { create(:user,email: 'company@example.com', role: 'company') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    
        describe 'GET #index' do
            context 'check user access' do
        
                it "college can view applications" do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)                
                    sign_in user2
                    get :index, params: { college_id: college.id}
                    expect(response).to render_template(:index)               
                end 
                it 'restricts access when individual tries to view the college show' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)     
                    sign_in user3
                    get :index, params: { college_id: college.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'when a company access the show, it is rendered status 200' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)     
                    sign_in user1
                    get :index ,params: { company_id: company.id}  
                    expect(response).to render_template(:index)
                end                
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                #let(:college) { build(:college, user: nil, name: 'Info institute of technology', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create an application when the current user's role is college" do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1) 
                    sign_in user2
                    post :create, params: { company_id: company.id}
                    expect(flash[:notice]).to eq('Applied Successfully !')
                end
                it 'an individual cannot create a college' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1) 
                    sign_in user3
                    post :create, params: { company_id: company.id }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a college' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1) 
                    sign_in user3
                    post :create, params: { company_id: company.id }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end       

end 
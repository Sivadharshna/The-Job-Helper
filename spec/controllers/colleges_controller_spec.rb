require 'rails_helper'

RSpec.describe CollegesController, type: :controller do

    let!(:user2) { create(:user, role: 'college') }
    let!(:user1) { create(:user,email: 'company@example.com', role: 'company') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }

    
        describe 'GET #show' do
            context 'check user access' do
        
                it "can access when college tries to view show" do
                    college=create(:college, user: user2)                 
                    sign_in user2
                    get :show, params: {id: college.id}
                    expect(response).to render_template(:show)               
                end 
                it 'restricts access when individual tries to view the college show' do
                    college=create(:college, user: user2)      
                    sign_in user3
                    get :show, params: {id: college.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'when a company access the show, it is rendered status 200' do
                    college=create(:college, user: user2) 
                    company=create(:company, user: user1)     
                    sign_in user1
                    get :show, params: {id: college.id}    
                    expect(response).to render_template(:show)
                end                
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                let(:college) { build(:college, user: nil, name: 'Info institute of technology', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create a college when the current user's role is college" do
                    sign_in user2
                    post :create, params: { college: college.attributes }
                    expect(flash[:notice]).to eq('Saved Sucessfully!')
                end
                it 'an individual cannot create a college' do
                    sign_in user3
                    post :create, params: { college: college.attributes }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a college' do
                    sign_in user3
                    post :create, params: { college: college.attributes }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end       

        describe 'PUT #update' do
            context 'check user access' do
                let(:college) { create(:college, user: user2, name: 'Info insititute of technology', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can update a college when the current user's role is college" do
                    sign_in user2
                    put :update, params: { id: college.id, college: { name: 'Angler technology Institute' } }
                    expect(flash[:notice]).to eq('Updated Sucessfully')
                    college.reload
                    expect(college.name).to eq('Angler technology Institute')
                end
                it 'an individual cannot update a college' do
                    sign_in user3
                    put :update, params: { id: college.id, college: { name: 'Angler technologies' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a company cannot update a college' do
                    sign_in user3
                    put :update, params: { id: college.id, college: { name: 'Angler technologies' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end 
            end
        end

        describe 'GET #new' do
            context 'check user access' do
                it 'renders the new template only if the user is college' do
                    sign_in user2
                    get :new
                    expect(response).to render_template(:new)
                end
                it 'doesn\'t render the new template only if the user is company' do
                    sign_in user1
                    get :new
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the new template only if the user is individual' do
                    sign_in user3
                    get :new
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #edit' do
            context 'check user access' do
                it 'renders the edit template if the user is college' do
                    sign_in user2
                    college=create(:college, user: user2)
                    get :edit, params: {id: college.id}
                    expect(response).to render_template(:edit)
                end
                it 'doesn\'t render the edit template if the user is company' do
                    sign_in user1
                    college=create(:college, user: user2)
                    get :edit, params: {id: college.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the edit template if the user is individual' do
                    sign_in user3
                    college=create(:college, user: user2)
                    get :edit, params: {id: college.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

end
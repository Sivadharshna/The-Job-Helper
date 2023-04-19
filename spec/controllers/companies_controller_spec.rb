require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}
    let!(:college2) {create(:college, user: user2)}
    let!(:course2) { create(:course, college: college2) }
    
    
        describe "GET #index" do
            context 'check user access' do
                it "redirects to root path when company tries to view index" do
                    sign_in user1
                    get :index
                    expect(response).to redirect_to(root_path)
                end
                it 'redirects to root path when individual tries to view the company index' do
                    sign_in user3
                    get :index
                    expect(response).to redirect_to(root_path)
                end
                it 'when a college access the index, it is rendered with the index' do
                    sign_in user2
                    get :index
                    expect(response).to render_template(:index)
                end
            end
        end
    
        describe 'GET #show' do
            context 'check user access' do
                let!(:company) { create(:company, user: user1)}
                it 'allows any valid user to see the show template' do
                    sign_in user1
                    get :show, params: {id: company.id}
                    expect(response).to render_template(:show)
                end
            end
        end

        describe "POST #create" do
            context 'check user access' do
                let(:company1) { build(:company, user: nil, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create a company when the current user's role is company" do
                    sign_in user1
                    post :create, params: { company: company1.attributes }
                    expect(flash[:notice]).to eq('Saved Sucessfully!')
                end
                it 'an individual cannot create a company' do
                    sign_in user3
                    post :create, params: { company: company1.attributes }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a company' do
                    sign_in user2
                    post :create , params: { company: company1.attributes}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'PUT #update' do
            context 'check user access' do
                let(:company) { create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can update a company when the current user's role is company" do
                    sign_in user1
                    put :update, params: { id: company.id, company: { name: 'Angler technologies' } }
                    expect(flash[:notice]).to eq('Updated Sucessfully!')
                    company.reload
                    expect(company.name).to eq('Angler technologies')
                end
                it 'an individual cannot create a company' do
                    sign_in user3
                    put :update, params: { id: company.id, company: { name: 'Angler technologies' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a company' do
                    sign_in user2
                    put :update, params: { id: company.id, company: { name: 'Angler technologies' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #new' do
            context 'check user access' do
                it 'renders the new template only if the user is company' do
                    sign_in user1
                    get :new
                    expect(response).to render_template(:new)
                end
                it 'doesn\'t render the new template only if the user is college' do
                    sign_in user2
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
                it 'renders the edit template only if the user is company' do
                    sign_in user1
                    company1=create(:company, user: user1)
                    get :edit, params: {id: user1.company.id}
                    expect(response).to render_template(:edit)
                end
                it 'doesn\'t render the edit template only if the user is college' do
                    sign_in user2
                    company1=create(:company, user: user1)
                    get :edit, params: {id: user1.company.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the edit template only if the user is individual' do
                    sign_in user3
                    company1=create(:company, user: user1)
                    get :edit, params: {id: user1.company.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'POST #select_students' do
            context 'check user access' do
                it "can select a student when current user's role is company" do
                    sign_in user1
                    student=create(:student, course: course2)
                    company=create(:company, user: user1)
                    post :select_students , params: { student_id: student.id, company_id: company.id}
                    expect(response).to have_http_status(:success)
                end
                it 'an individual cannot select students' do
                    sign_in user3
                    student=create(:student, course: course2)
                    company=create(:company, user: user1)
                    post :select_students , params: { student_id: student.id, company_id: company.id }
                    expect(flash[:notice]).to eq('Restricted Access')
                end
                it 'a college cannot select students' do
                    sign_in user2
                    student=create(:student, course: course2)
                    company=create(:company, user: user1)
                    post :select_students , params: { student_id: student.id, company_id: company.id }
                    expect(flash[:notice]).to eq('Restricted Access')
                end
            end
        end

        
end
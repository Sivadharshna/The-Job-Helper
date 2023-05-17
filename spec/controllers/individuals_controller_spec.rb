require 'rails_helper'

RSpec.describe  IndividualsController, type: :controller do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }    

    
        describe 'GET #show' do
            context 'check user access' do
                it 'allows any valid user individual to see the show template' do
                    individual = create(:individual, user: user3)
                    sign_in user3
                    get :show, params: {id: individual.id}
                    expect(response).to render_template(:show)
                end
                it 'allows any valid user company to see the show template' do
                    individual = create(:individual, user: user3)                    
                    company= create(:company, user: user1)
                    job=create(:job, company: company)
                    @individual_application=create(:individual_application, individual: individual, job: job)
                    sign_in user1
                    get :show, params: {id: individual.id}
                    expect(response).to render_template(:show)
                end
                it 'does not allow any college to see the show template' do
                    individual = create(:individual, user: user3)
                    sign_in user2
                    get :show, params: {id: individual.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                end
            end
        end

        describe "POST #create" do
            context 'check user access' do
                let(:individual1) { build(:individual, user: nil, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create a individual when the current user's role is individual" do
                    sign_in user3
                    post :create, params: { individual: individual1.attributes }
                    expect(flash[:notice]).to eq('Profile created successfully !')
                end
                it 'an company cannot create a individual' do
                    sign_in user1
                    post :create, params: { individual: individual1.attributes }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a individual' do
                    sign_in user2
                    post :create , params: { individual: individual1.attributes}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'PUT #update' do
            context 'check user access' do
                let(:individual) { create(:individual, user: user1, name: 'Arunmohan', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can update a individual when the current user's role is individual" do
                    sign_in user3
                    individual=create(:individual, user: user3)
                    put :update, params: { id: individual.id, individual: { name: 'Mohan' } }
                    expect(flash[:notice]).to eq('Profile Updated successfully !')
                    individual.reload
                    expect(individual.name).to eq('Mohan')
                end
                it 'an company cannot create a individual' do
                    sign_in user1
                    put :update, params: { id: individual.id, individual: { name: 'Mohan' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a individual' do
                    sign_in user2
                    put :update, params: { id: individual.id, individual: { name: 'Mohan' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #new' do
            context 'check user access' do
                it 'renders the new template only if the user is individual' do
                    sign_in user3
                    get :new
                    expect(response).to render_template(:new)
                end
                it 'doesn\'t render the new template only if the user is college' do
                    sign_in user2
                    get :new
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the new template only if the user is company' do
                    sign_in user1
                    get :new
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #edit' do
            context 'check user access' do
                it 'renders the edit template only if the user is individual' do
                    sign_in user3
                    individual=create(:individual, user: user3)
                    get :edit, params: {id: individual.id}
                    expect(response).to render_template(:edit)
                end
                it 'doesn\'t render the edit template only if the user is college' do
                    sign_in user2
                    individual=create(:individual, user: user1)
                    get :edit, params: {id: individual.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the edit template only if the user is company' do
                    sign_in user1
                    individual=create(:individual, user: user1)
                    get :edit, params: {id: individual.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

end
require 'rails_helper'

RSpec.describe JobsController, type: :controller do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }
    
        describe "GET #index" do
            let!(:company) { create(:company, user: user1) }
            let!(:job) { create(:job , company: company) }
            context 'check user access' do
                it "when a company access the index, it redirected to root path" do
                    sign_in user1
                    get :index
                    expect(response).to redirect_to(root_path)
                end
                it 'when a individual access the index, it is rendered with the index' do
                    sign_in user3
                    individual=create(:individual, user: user3)
                    get :index
                    expect(response).to render_template(:index)
                end
                it 'redirects to root path when college tries to view the index' do
                    sign_in user2
                    get :index
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe "GET #specific" do
            let!(:company) { create(:company, user: user1) }
            let!(:job) { create(:job , company: company) }
            context 'check user access' do
                it "when a company access the specific jobs, it is rendered with the index" do
                    sign_in user1
                    get :specific
                    expect(response).to render_template(:specific)
                end
                it 'when a individual access the specific, it is rendered with the index' do
                    sign_in user3
                    individual=create(:individual, user: user3)
                    get :specific
                    expect(response).to render_template(:specific)
                end
                it 'redirects to root path when college tries to view the index' do
                    sign_in user2
                    get :specific
                    expect(response).to redirect_to(root_path)
                end
            end
        end
    
        describe 'GET #show' do
            let!(:company) { create(:company, user: user1) }
            let!(:job) { create(:job , company: company) }
            context 'check user access' do
                let!(:company) { create(:company, user: user1)}
                it 'allows individual to see the show template' do
                    sign_in user3
                    individual=create(:individual, user: user3)
                    get :show, params: {company_id: company.id, id: job.id}
                    expect(response).to render_template(:show)
                end
                it 'allow company to see the show template' do
                    sign_in user1
                    individual=create(:individual, user: user3)
                    get :show, params: {company_id: company.id, id: job.id}
                    expect(response).to render_template(:show)
                end
                it 'does not allow college to see the show template' do
                    sign_in user2
                    get :show, params: {company_id: company.id, id: job.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                end
            end
        end

        describe "POST #create" do
            context 'check user access' do
                let!(:company) { create(:company, user: user1) }
                let!(:job) { build(:job , company: company) }                
                it "can create a job when the current user's role is company" do
                    sign_in user1
                    post :create, params: { company_id: company.id, job: job.attributes }
                    expect(flash[:notice]).to eq('Saved Successfully')
                end
                it 'an individual cannot create a job' do
                    sign_in user3
                    post :create, params: { company_id: company.id, job: job.attributes }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot create a job' do
                    sign_in user2
                    post :create , params: { company_id: company.id, job: job.attributes }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'PUT #update' do
            context 'check user access' do
                let!(:company) { create(:company, user: user1) }
                let!(:job) { create(:job , company: company) }   
                it "can update a job when the current user's role is company" do
                    sign_in user1
                    put :update, params: { company_id: company.id,id: job.id, job: { name: 'Associate software developer' } }
                    expect(flash[:notice]).to eq('Updated Successfully')
                    job.reload
                    expect(job.name).to eq('Associate software developer')
                end
                it 'an individual cannot update a job' do
                    sign_in user3
                    put :update, params: { company_id: company.id,id: job.id, job: { name: 'Associate software developer' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'a college cannot update a job' do
                    sign_in user2
                    put :update, params: { company_id: company.id,id: job.id, job: { name: 'Associate software developer' } }
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #new' do
            let!(:company) { create(:company, user: user1) }
            context 'check user access' do
                it 'renders the new template only if the user is company' do
                    sign_in user1
                    get :new, params: {company_id: company.id}
                    expect(response).to render_template(:new)
                end
                it 'doesn\'t render the new template if the user is college' do
                    sign_in user2
                    get :new, params: {company_id: company.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the new template if the user is individual' do
                    sign_in user3
                    get :new, params: {company_id: company.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #edit' do
            let!(:company) { create(:company, user: user1) }
            let!(:job) { create(:job , company: company) }   
            context 'check user access' do
                it 'renders the edit template only if the user is company' do
                    sign_in user1
                    get :edit, params: {company_id: company.id, id: job.id}
                    expect(response).to render_template(:edit)
                end
                it 'doesn\'t render the edit template if the user is college' do
                    sign_in user2
                    get :edit, params: {company_id: company.id, id: job.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
                it 'doesn\'t render the edit template if the user is individual' do
                    sign_in user3
                    get :edit, params: {company_id: company.id, id: job.id}
                    expect(flash[:notice]).to eq('Restricted Access')
                    expect(response).to redirect_to(root_path)
                end
            end
        end
        
end
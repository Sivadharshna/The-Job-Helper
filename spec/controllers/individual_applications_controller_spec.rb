require 'rails_helper'

RSpec.describe IndividualApplicationsController, type: :controller do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }

    describe 'GET #index' do
        context 'check user access' do
            it 'a company can view the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                sign_in user1
                get :index, params: { company_id: company.id , job_id: job.id}
                expect(response).to render_template(:index)
            end
            it 'an individual can view the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                sign_in user3
                get :index, params: { individual_id: individual.id }
                expect(response).to render_template(:index)
            end
            it 'a college cannot view the individual application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=create(:individual_application, individual: individual, job: job)
                sign_in user2
                get :index, params: { individual_id: individual.id  }
                expect(response).to_not render_template(:index)
            end
        end
    end

    describe 'POST #create' do
        context 'check user access' do
            it 'a company cannot create the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=build(:individual_application, individual: individual, job: job)
                sign_in user1
                post :create, params: { job_id: job.id , individual_application: application.attributes}
                expect(flash[:notice]).to eq('Restricted Access')
                expect(response).to redirect_to(root_path)
            end
            it 'an individual can create the application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=build(:individual_application, individual: individual, job: job)
                sign_in user3
                post :create, params: { job_id: job.id  ,individual_application: application.attributes}
                expect(flash[:notice]).to eq('Applied Successfully !')
            end
            it 'a college cannot create the individual application' do
                company= create(:company, user: user1)
                individual=create(:individual, user: user3)
                job=create(:job, company: company)
                application=build(:individual_application, individual: individual, job: job)
                sign_in user2
                post :create, params: { job_id: job.id ,individual_application: application.attributes}
                expect(flash[:notice]).to eq('Restricted Access')
                expect(response).to redirect_to(root_path)
            end
        end
    end

end
require 'rails_helper'

RSpec.describe  IndividualsController, type: :request do

    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }
    
        describe 'GET #show' do
            context 'check user access' do
                it 'allows any valid user individual to see the show template' do
                    individual = create(:individual, user: user3)
                    get '/api/v1/individuals/'+individual.id.to_s , params: { access_token: user3_token.token, format: :json }
                    expect(response).to have_http_status(200)
                end
                it 'allows any valid user company to see the show template' do
                    individual = create(:individual, user: user3)
                    company=create(:company, user: user1)
                    job=create(:job, company: company)
                    individual_application=create(:individual_application, job: job, individual: individual)
                    get '/api/v1/individuals/'+individual.id.to_s , params: { access_token: user1_token.token, format: :json }
                    expect(response).to have_http_status(200)
                end
                it 'does not allow any college to see the show template' do
                    individual = create(:individual, user: user3)
                    get '/api/v1/individuals/'+individual.id.to_s, params: { access_token: user2_token.token, format: :json }
                    expect(response).to have_http_status(403)
                end
            end
        end

        describe "POST #create" do
            context 'check user access' do
                let(:individual) { build(:individual, user: nil, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can create a individual when the current user's role is individual" do
                    post '/api/v1/individuals', params: { access_token: user3_token.token, format: :json, individual: individual.attributes}
                    expect(response).to have_http_status(200)
                end
                it 'an company cannot create a individual' do
                    post '/api/v1/individuals', params: { access_token: user1_token.token, format: :json, individual: individual.attributes }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot create a individual' do
                    post '/api/v1/individuals', params: { access_token: user2_token.token, format: :json, individual: individual.attributes }
                    expect(response).to have_http_status(403)
                end
            end
        end

        describe 'PUT #update' do
            context 'check user access' do
                let(:individual) { create(:individual, user: user3, name: 'Arunmohan', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can update a individual when the current user's role is individual" do
                    put '/api/v1/individuals/'+individual.id.to_s, params: { access_token: user3_token.token, format: :json, individual: individual.attributes }
                    expect(response).to have_http_status(200)
                end
                it 'an company cannot create a individual' do
                    put '/api/v1/individuals/'+individual.id.to_s, params: { access_token: user1_token.token, format: :json, individual: individual.attributes }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot create a individual' do
                    put '/api/v1/individuals/'+individual.id.to_s, params: { access_token: user2_token.token, format: :json, individual: individual.attributes }
                    expect(response).to have_http_status(403)
                end
            end
        end

end
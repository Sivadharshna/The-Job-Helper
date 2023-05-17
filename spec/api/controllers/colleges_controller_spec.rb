require 'rails_helper'

RSpec.describe Api::V1::CollegesController, type: :request do

    let!(:user2) { create(:user, role: 'college') }
    let!(:user1) { create(:user,email: 'company@example.com', role: 'company') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }

    let!(:application) { create(:doorkeeper_application)}

    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}
    
        describe 'GET #show' do
            context 'check user access' do
                let!(:college) { create(:college, user: user2)}
                let!(:company) { create(:company, user: user1)}
                it "can access when college tries to view show" do
                    get '/api/v1/colleges/'+college.id.to_s, params: { access_token: user2_token.token, format: :json }
                    expect(response).to have_http_status(200)
                end 
                it 'restricts access when individual tries to view the college show' do
                    get '/api/v1/colleges/'+college.id.to_s, params: { access_token: user3_token.token, format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'when a company access the show, it is rendered status 200' do
                    get '/api/v1/colleges/'+college.id.to_s, params: { access_token: user1_token.token, format: :json }
                    expect(response).to have_http_status(200)
                end
            end
        end

        describe "POST #create" do 
            context 'check user access' do
                let(:college) { build(:college, user: nil, name: 'Info institute of technology', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}

                it "can create a college when the current user's role is college" do
                    post '/api/v1/colleges' , params: { access_token: user2_token.token, college: college.attributes, format: :json }
                    expect(response).to have_http_status(200)
                end
                it 'an individual cannot create a college' do
                    post '/api/v1/colleges', params: { access_token: user3_token.token, college: college.attributes ,format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot create a college' do
                    post '/api/v1/colleges', params: { access_token: user1_token.token, college: college.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end
            end
        end       

        describe 'PUT #update' do
            context 'check user access' do
                let(:college) { create(:college, user: user2, name: 'Info insititute of technology', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')}
                it "can update a college when the current user's role is college" do
                    put '/api/v1/colleges/'+college.id.to_s , params: { access_token: user2_token.token, college: college.attributes,format: :json }
                    expect(response).to have_http_status(200)
                end
                it 'an individual cannot update a college' do
                    put '/api/v1/colleges/'+college.id.to_s , params: { access_token: user3_token.token, college: college.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'a company cannot update a college' do
                    put '/api/v1/colleges/'+college.id.to_s , params: { access_token: user1_token.token, college: college.attributes,format: :json }
                    expect(response).to have_http_status(403)
                end 
            end
        end

        describe 'POST #select_students' do
            context 'check user access' do
                let!(:college) {create(:college, user: user2)}
                let!(:course2) { create(:course, college: college) }
                it "can select a student when current user's role is company" do
                    company = create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')
                    student = create(:student, course: course2)
                    @college_application=create(:college_application, college: college, company: company)
                    post '/api/v1/college_applications/'+@college_application.id.to_s+'/students/'+student.id.to_s+'/select_students' , params: { access_token: user1_token.token, company: company.attributes, format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'an individual cannot select students' do
                    company = create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')
                    student = create(:student, course: course2)
                    @college_application=create(:college_application, college: college, company: company)
                    post '/api/v1/college_applications/'+@college_application.id.to_s+'/students/'+student.id.to_s+'/select_students' , params: { access_token: user3_token.token, company: company.attributes, format: :json }
                    expect(response).to have_http_status(403)
                end
                it 'a college cannot select students' do
                    company = create(:company, user: user1, name: 'Infosys India', email_id: 'infoindia@gmail.com',  contact_no: '9876543212')
                    student = create(:student, course: course2)
                    @college_application=create(:college_application, college: college, company: company)
                    post '/api/v1/college_applications/'+@college_application.id.to_s+'/students/'+student.id.to_s+'/select_students'  , params: { access_token: user2_token.token, company: company.attributes, format: :json }
                    expect(response).to have_http_status(200)
                end
            end
        end

end
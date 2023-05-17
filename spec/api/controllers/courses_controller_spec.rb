require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual') }

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}
    
    let!(:permission1) { create(:permission, status: 'Permitted' , user: user1 ) }
    let!(:permission2) { create(:permission, status: 'Permitted' , user: user2 ) }
    
    describe 'POST #create' do
        context 'check user access' do
            it 'allows only a college to create course' do
                college=create(:college, user: user2)
                course=build(:course, college: nil)
                post '/api/v1/colleges/'+college.id.to_s+'/courses' , params: { access_token: user2_token.token, college: college.attributes, course: course.attributes, format: :json }
                expect(response).to have_http_status(200)
            end
            it 'doesn\'t allow a individual to create course' do
                college=create(:college, user: user2)
                course=build(:course, college: nil)
                post '/api/v1/colleges/'+college.id.to_s+'/courses' , params: { access_token: user3_token.token, college: college.attributes, course: course.attributes, format: :json }
                expect(response).to have_http_status(403)
            end
            it 'doesn\'t allow a company to create course' do
                college=create(:college, user: user2)
                course=build(:course, college: nil)
                post '/api/v1/colleges/'+college.id.to_s+'/courses' , params: { access_token: user1_token.token, college: college.attributes, course: course.attributes, format: :json }
                expect(response).to have_http_status(403)
            end
        end
    end

    describe 'PUT #update' do
        context 'check user access' do
            it 'only college can update the course' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                put '/api/v1/colleges/'+college.id.to_s+'/courses/'+course.id.to_s ,params: { access_token: user2_token.token, college: college.attributes, course: course.attributes, format: :json }
                expect(response).to have_http_status(200)
            end
            it 'a company cannot update the course' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                put '/api/v1/colleges/'+college.id.to_s+'/courses/'+course.id.to_s ,params: { access_token: user1_token.token, college: college.attributes, course: course.attributes, format: :json }
                expect(response).to have_http_status(403)
            end
            it 'an individual cannot update the course' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                put '/api/v1/colleges/'+college.id.to_s+'/courses/'+course.id.to_s ,params: { access_token: user3_token.token, college: college.attributes, course: course.attributes, format: :json }
                expect(response).to have_http_status(403)
            end
        end
    end

    describe 'DELETE #destroy' do
        context 'check user access' do
            it 'allow a college to destroy the course' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                delete '/api/v1/colleges/'+college.id.to_s+'/courses/'+course.id.to_s ,params: { id: course, access_token: user2_token.token, college: college.attributes, format: :json }
                expect(response).to have_http_status(200)
            end
            it 'does not allow a company to destroy a course' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                delete '/api/v1/colleges/'+college.id.to_s+'/courses/'+course.id.to_s ,params: { id: course, access_token: user1_token.token, college: college.attributes, format: :json }
                expect(response).to have_http_status(403)
            end
            it 'does not allow a individual to destroy a course' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                delete '/api/v1/colleges/'+college.id.to_s+'/courses/'+course.id.to_s ,params: { id: course, access_token: user3_token.token, college: college.attributes, format: :json }
                expect(response).to have_http_status(403)
            end
        end
    end

end
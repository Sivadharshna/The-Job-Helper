require 'rails_helper'

RSpec.describe StudentsController, type: :request do
    
    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}

    let!(:application) { create(:doorkeeper_application)}

    let!(:user1_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user1.id)}
    let!(:user2_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user2.id)}
    let!(:user3_token) { create(:doorkeeper_access_token, application: application, resource_owner_id: user3.id)}
    describe 'Get #index' do
    
        context 'check user access' do
            it 'allows a college to view students' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get '/api/v1/colleges/'+college.id.to_s+'/students' , params: { college_id: college.id ,access_token: user2_token.token, format: :json}
                expect(response).to have_http_status(200)
            end 
            it 'does not allows a company to view students index of a college' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get '/api/v1/colleges/'+college.id.to_s+'/students' , params: { college_id: college.id  ,access_token: user1_token.token, format: :json}
                expect(response).to have_http_status(403)
            end
            it 'does not allow an individual to view students' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get '/api/v1/colleges/'+college.id.to_s+'/students' , params: { college: college.id ,access_token: user3_token.token, format: :json}
                expect(response).to have_http_status(403)
            end
        end
    end

    describe 'POST #create' do
        context 'check user access' do
            it 'allows a college to create a student' do
               
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=build(:student, course: nil)
                post '/api/v1/courses/'+course.id.to_s+'/students', params: { course_id: course.id, student: student.attributes,access_token: user2_token.token, format: :json }
                expect(response).to have_http_status(200) 
            end
            it 'does not allow a company to create a student' do
                
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=build(:student, course: nil)
                post '/api/v1/courses/'+course.id.to_s+'/students', params: { course_id: course.id, student: student.attributes, access_token: user1_token.token, format: :json }
                expect(response).to have_http_status(403)
            end 
            it 'does not allow a company to create a student' do
                
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=build(:student, course: nil)
                post '/api/v1/courses/'+course.id.to_s+'/students', params: { course_id: course.id, student: student.attributes, access_token: user3_token.token, format: :json }
                expect(response).to have_http_status(403)
            end 
        end
    end

    describe 'POST #update' do
        context 'check user access' do
            it 'allows a college to update a student' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                put '/api/v1/courses/'+course.id.to_s+'/students/'+student.id.to_s , params: { course_id: course.id, id: student.id , student: {name: 'Mohan' }, access_token: user2_token.token, format: :json}
                expect(response).to have_http_status(200)
            end
            it 'does not allow a company to create a student' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                put '/api/v1/courses/'+course.id.to_s+'/students/'+student.id.to_s , params: { course_id: course.id, id: student.id ,student: {name: 'Mohan' } ,access_token: user1_token.token, format: :json}
                expect(response).to have_http_status(403)
            end 
            it 'does not allow a company to create a student' do
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                put '/api/v1/courses/'+course.id.to_s+'/students/'+student.id.to_s, params: { course_id: course.id, id: student.id, student: { name: 'Mohan' } ,access_token: user3_token.token, format: :json}
                expect(response).to have_http_status(403)
            end 
        end
    end

    describe 'DELETE #destroy' do
        context 'check user access' do
            it 'allows only a college to delete a student' do
                
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                delete '/api/v1/courses/'+course.id.to_s+'/students/'+student.id.to_s , params: { id: student.id, course_id: course.id, access_token: user2_token.token, format: :json }
                expect(response).to have_http_status(200)
            end
            it 'does not allow a company to delete a student' do
                
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                delete '/api/v1/courses/'+course.id.to_s+'/students/'+student.id.to_s, params: { id: student.id, course_id: course.id, access_token: user1_token.token, format: :json }
                expect(response).to have_http_status(403)
            end
            it 'does not allow an individual to delete a student' do
                
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                delete '/api/v1/courses/'+course.id.to_s+'/students/'+student.id.to_s, params: { id: student.id, course_id: course.id , access_token: user3_token.token, format: :json}
                expect(response).to have_http_status(403)
            end
        end
    end
end
                

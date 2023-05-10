require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
    
    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}
    describe 'Get #index' do
    
        context 'check user access' do
            it 'allows a college to view students' do
                sign_in user2
                college=create(:college, user: user2)
                get :index , params: { college_id: college.id }
                expect(response).to render_template(:index)
            end 
            it 'allows a company to view students index of a college' do
                sign_in user1
                company=create(:company, user: user1)
                college=create(:college, user: user2)
                get :index , params: { college_id: college.id }
                expect(response).to render_template(:index)
            end
            it 'does not allow an individual to view students' do
                sign_in user3
                college=create(:college, user: user2)
                get :index , params: { college_id: college.id }
                expect(flash[:notice]).to eq('Restricted Access')
                expect(response).to_not render_template(:index)
            end
        end
    end

    describe 'GET #new' do
        context 'check user access' do
            it 'allows only a college to create new students' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get :new, params: {course_id: course.id}
                expect(response).to render_template(:new)
            end
            it 'does not allow a company to create new students' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get :new, params: {course_id: course.id}
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'does not allow an individual to create new students' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get :new, params: {course_id: course.id}
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end

    describe 'POST #create' do
        context 'check user access' do
            it 'allows a college to create a student' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=build(:student, course: nil)
                post :create, params: { course_id: course.id, student: student.attributes }
                expect(flash[:notice]).to eq('Created Successfully')
            end
            it 'does not allow a company to create a student' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=build(:student, course: nil)
                post :create, params: { course_id: course.id, student: student.attributes }
                expect(flash[:notice]).to eq('Restricted Access')
            end 
            it 'does not allow a company to create a student' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=build(:student, course: nil)
                post :create, params: { course_id: course.id, student: student.attributes }
                expect(flash[:notice]).to eq('Restricted Access')
            end 
        end
    end

    describe 'GET #edit' do
        context 'check user access' do
            it 'allows only a college to edit students' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                get :edit, params: {course_id: course.id, id: student.id}
                expect(response).to render_template(:edit)
            end
            it 'does not allow a company to edit students' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                get :edit, params: {course_id: course.id, id: student.id}
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'does not allow an individual to edit students' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                get :edit, params: {course_id: course.id, id: student.id}
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end

    describe 'POST #update' do
        context 'check user access' do
            it 'allows a college to update a student' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                put :update, params: { course_id: course.id, id: student.id , student: {name: 'Mohan' }}
                expect(flash[:notice]).to eq('Updated Successfully!')
            end
            it 'does not allow a company to create a student' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                put :update, params: { course_id: course.id, id: student.id ,student: {name: 'Mohan' } }
                expect(flash[:notice]).to eq('Restricted Access')
            end 
            it 'does not allow a company to create a student' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                put :update, params: { course_id: course.id, id: student.id, student: { name: 'Mohan' } }
                expect(flash[:notice]).to eq('Restricted Access')
            end 
        end
    end

    describe 'DELETE #destroy' do
        context 'check user access' do
            it 'allows only a college to delete a student' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                delete :destroy , params: { id: student.id, course_id: course.id }
                expect(flash[:notice]).to eq('Deleted Successfully')
            end
            it 'does not allow a company to delete a student' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                delete :destroy , params: { id: student.id, course_id: course.id }
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'does not allow an individual to delete a student' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                student=create(:student, course: course)
                delete :destroy , params: { id: student.id, course_id: course.id }
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end
end
                

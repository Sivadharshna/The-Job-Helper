require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual') }

    describe 'GET #new' do
        context 'check user access' do
            it 'only college can create courses' do
                sign_in user2
                college=create(:college, user: user2)
                get :new, params: {college_id: college.id}
                expect(response).to render_template(:new)
            end
            it 'individual cannot create courses' do
                sign_in user3
                college=create(:college, user: user2)
                get :new, params: {college_id: college.id}
                expect(flash[:notice]).to eq('Restricted Access')
                expect(response).to redirect_to(root_path)
            end
            it 'company cannot create courses' do
                sign_in user1
                college=create(:college, user: user2)
                get :new, params: {college_id: college.id}
                expect(flash[:notice]).to eq('Restricted Access')
                expect(response).to redirect_to(root_path)
            end
        end
    end

    describe 'POST #create' do
        context 'check user access' do
            it 'allows only a college to create course' do
                sign_in user2
                college=create(:college, user: user2)
                course=build(:course, college: nil)
                post :create, params: { course: course.attributes, college_id: college.id }
                expect(flash[:notice]).to eq('Saved Successfully!')
            end
            it 'doesn\'t allow a individual to create course' do
                sign_in user3
                college=create(:college, user: user2)
                course=build(:course, college: nil)
                post :create, params: { college_id: college.id, course: course.attributes  }
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'doesn\'t allow a company to create course' do
                sign_in user1
                college=create(:college, user: user2)
                course=build(:course, college: nil)
                post :create, params: { course: course.attributes, college_id: college.id }
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end

    describe 'GET #edit' do
        context 'check user access' do
            it 'only a college can edit course' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get :edit, params: { id: course, college_id: college.id }
                expect(response).to render_template(:edit)
            end
            it 'does not allow a company to edit' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college:  college)
                get :edit, params: { id: course , college_id: college.id }
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'does not allow a individual to edit' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                get :edit, params: {id: course}
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end

    describe 'PUT #update' do
        context 'check user access' do
            it 'only college can update the course' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                put :update, params: { id: course, course: course.attributes, college_id: college.id}
                expect(flash[:notice]).to eq('Updated Successfully!')
            end
            it 'a company cannot update the course' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                put :update, params: { id: course, course: course.attributes, college_id: college.id}
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'an individual cannot update the course' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                put :update, params: { id: course, course: course.attributes, college_id: college.id}
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end

    describe 'DELETE #destroy' do
        context 'check user access' do
            it 'allow a college to destroy the course' do
                sign_in user2
                college=create(:college, user: user2)
                course=create(:course, college: college)
                delete :destroy, params: { id: course }
                expect(flash[:notice]).to eq('Deleted Successfully')
            end
            it 'does not allow a company to destroy a course' do
                sign_in user1
                college=create(:college, user: user2)
                course=create(:course, college: college)
                delete :destroy, params: { id: course }
                expect(flash[:notice]).to eq('Restricted Access')
            end
            it 'does not allow a individual to destroy a course' do
                sign_in user3
                college=create(:college, user: user2)
                course=create(:course, college: college)
                delete :destroy, params: { id: course }
                expect(flash[:notice]).to eq('Restricted Access')
            end
        end
    end

end
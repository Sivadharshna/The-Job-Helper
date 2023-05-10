require 'rails_helper'

RSpec.describe CollegeApplication, type: :model do


    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user1) { create(:user, role: 'company') }

    describe 'default value' do
        context ' for status ' do
            it 'checks the default value is set for status' do
                college=create(:college,user: user2)
                company=create(:company, user: user1)
                clgappl=build(:college_application, college: college, company: company)
                clgappl.validate
                expect(clgappl.status).to eq('Under progress')
            end
        end
    end

    describe 'associations for college application' do
        context 'college' do
            it 'college_applications belongs to colleges' do
                t=CollegeApplication.reflect_on_association(:college)
                expect(t.macro).to eq(:belongs_to)
            end
        end
        context 'accepted offer' do
            it 'college application has one accepted offer' do
                t=CollegeApplication.reflect_on_association(:accepted_offer)
                expect(t.macro).to eq(:has_one)
            end
        end
        context 'company' do
            it 'college applications belongs to companies' do
                t=CollegeApplication.reflect_on_association(:company)
                expect(t.macro).to eq(:belongs_to)
            end
        end
    end

end
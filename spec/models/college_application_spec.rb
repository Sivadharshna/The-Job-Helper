require 'rails_helper'

RSpec.describe CollegeApplication, type: :model do

    describe 'default value' do
        context ' for status ' do
            it 'checks the default value is set for status' do
                clgappl=build(:college_application)
                expect(clgappl.status).to eq('Under Progress')
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
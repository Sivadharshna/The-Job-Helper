require 'rails_helper'

RSpec.describe Course, type: :model do

    describe 'validates the' do
        context 'name' do 

            it 'it is invalid to have the name nil' do
                course=build(:course, name: '')
                course.validate
                expect(course.errors).to include(:name)    
            end
            it 'it is valid to have some string in name' do
                course=build(:course)
                course.validate
                expect(course.errors).to_not include(:name)    
            end
        end
    end

    describe 'associations for course' do
        context 'college' do
            it 'belongs to one college' do
                t=Course.reflect_on_association(:college)
                expect(t.macro).to eq(:belongs_to)
            end
        end

        context 'student' do
            it 'course has many students' do
                t=Course.reflect_on_association(:students)
                expect(t.macro).to eq(:has_many)
            end
        end
    end
end
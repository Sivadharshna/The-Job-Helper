require 'rails_helper'

RSpec.describe Student, type: :model do
    

    describe 'validates the' do
        context 'name' do 

            it 'it is invalid to have the name nil' do
                student=build(:student, name: '')
                student.validate
                expect(student.errors).to include(:name)    
            end
            it 'it is valid to have some string in name' do
                student=build(:student)
                student.validate
                expect(student.errors).to_not include(:name)    
            end

        end
        
        context 'sslc percentage' do

            it 'it is invalid to have the sslc percentage nil' do
                student=build(:student, sslc_percentage: nil)
                student.validate
                expect(student.errors).to include(:sslc_percentage)    
            end
            it 'it is valid to have some number in sslc percentage' do
                student=build(:student)
                student.validate
                expect(student.errors).to_not include(:sslc_percentage)    
            end

        end

        context 'hsc/diplomo percentage' do

            it 'it is invalid to have the hsc/diplomo percentage nil' do
                student=build(:student, hsc_diplomo_percentage: nil)
                student.validate
                expect(student.errors).to include(:hsc_diplomo_percentage)    
            end
            it 'it is valid to have some number in hsc/diplomo percentage' do
                student=build(:student)
                student.validate
                expect(student.errors).to_not include(:hsc_diplomo_percentage)    
            end

        end

        context 'cgpa' do

            it 'it is invalid to have the cgpa nil' do
                student=build(:student, cgpa: nil)
                student.validate
                expect(student.errors).to include(:cgpa)    
            end
            it 'it is valid to have some number in cgpa' do
                student=build(:student, cgpa: 8.6)
                student.validate
                expect(student.errors).to_not include(:cgpa)    
            end

        end

        context 'hsc/diplomo ' do

            it 'it is invalid to have the hsc/diplomo nil' do
                student=build(:student, hsc_diplomo: nil)
                student.validate
                expect(student.errors).to include(:hsc_diplomo)    
            end
            it 'it is invalid to have any other string than HSC/DIPLOMO as hsc/diplomo' do
                student=build(:student, hsc_diplomo: 'any thing other')
                student.validate
                expect(student.errors).to include(:hsc_diplomo)    
            end
            it 'it is valid to have some number in hsc/diplomo' do
                student=build(:student, hsc_diplomo: 'DIPLOMO')
                student.validate
                expect(student.errors).to_not include(:hsc_diplomo)    
            end

        end

        context 'graduation_year' do

            it 'it is invalid to have the graduation year nil' do
                student=build(:student, graduation_year: nil)
                student.validate
                expect(student.errors).to include(:graduation_year)    
            end
            it 'it is valid to have some number in graduation number of length 4' do
                student=build(:student)
                student.validate
                expect(student.errors).to_not include(:graduation_year)    
            end
            it 'it is invalid to have some number in graduation number of length < 4' do
                student=build(:student, graduation_year: 308)
                student.validate
                expect(student.errors).to include(:graduation_year)    
            end
            it 'it is invalid to have some number in graduation number of length > 4' do
                student=build(:student, graduation_year: 3080)
                student.validate
                expect(student.errors).to_not include(:graduation_year)    
            end

        end

        context 'case conversion' do
            it 'hsc/diplomo changes to upcase' do
                student=build(:student)
                student.validate
                expect(student.hsc_diplomo).to eq('HSC')
            end
        end
    end
    
    describe 'associations for students' do
        context 'course' do
            it 'belongs to one course' do
                t=Student.reflect_on_association(:course)
                expect(t.macro).to eq(:belongs_to)
            end
        end
    end

end
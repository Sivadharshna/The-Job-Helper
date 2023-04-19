require 'rails_helper'

RSpec.describe Job , type: :model do
    
    describe ' validate the ' do
        context 'name' do
            it 'Has error in presence of name when input is nil' do
            job=build(:job, name: '')
            job.validate
            expect(job.errors).to include(:name)
            end
            it 'Has no error in presence of name when input is some string' do
            job=build(:job)
            job.validate
            expect(job.errors).to_not include(:name)
            end    
        end

        context 'salary' do

            it 'the salary is not nil' do
                job=build(:job, salary: nil) 
                job.validate
                expect(job.errors).to include(:salary)
            end

            it 'the salary is not zero' do
                job=build(:job, salary: 0)
                job.validate
                expect(job.errors).to include(:salary)
            end

            it 'the salary is not negative' do
                job=build(:job, salary: -3.5)
                job.validate
                expect(job.errors).to include(:salary)
            end 

            it 'check that salary is a valid number' do
                job=build(:job)
                job.validate
                expect(job.errors).to_not include(:salary)
            end

        end

        context 'minimum educational qualification' do
            it 'should be present then no errors' do
                job=build(:job)
                job.validate
                expect(job.errors).to_not include(:minimum_educational_qualification)
            end

            it 'not present then there mubstt be a error' do
                job=build(:job, minimum_educational_qualification: '')
                job.validate
                expect(job.errors).to include(:minimum_educational_qualification)
            end
        end
    end

    describe 'foreign key' do
        context 'company' do
            it ' job is hold by a company' do
                job=build(:job, company_id: '')
                job.validate
                expect(job.errors).to include(:company)
            end

            it 'job is not hold by a company then error' do
                job=build(:job)
                job.validate
                expect(job.errors).to_not include(:company)
            end
        end
    end

    describe ' associations of job ' do
        context ' company ' do
            it ' job belongs to a company ' do
                t=Job.reflect_on_association(:company)
                expect(t.macro).to eq(:belongs_to)
            end
        end

        context 'individual_applications' do
            it 'job has many individual applications' do
                t=Job.reflect_on_association(:individual_applications)
                expect(t.macro).to eq(:has_many)
            end
        end

        context 'jobs' do
            it 'jobs has many individuals through individual applications ' do
                t=Job.reflect_on_association(:individuals)
                expect(t.macro).to eq(:has_many)
                expect(t.options[:through]).to eq(:individual_applications)
            end
        end
    end

end
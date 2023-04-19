require 'rails_helper'
 
RSpec.describe Individual ,type: :model do
    
    describe 'validates the' do
        context 'name' do 

            it 'it is invalid to have the name nil' do
                individual=build(:individual, name: '')
                individual.validate
                expect(individual.errors).to include(:name)    
            end
            it 'it is valid to have some string in name' do
                individual=build(:individual)
                individual.validate
                expect(individual.errors).to_not include(:name)    
            end

        end

        context 'email' do

            it 'it is invalid to have the email nil' do
                individual=build(:individual, name: '')
                individual.validate
                expect(individual.errors).to include(:name)    
            end
            it 'it is valid to have some valid string in email' do
                individual=build(:individual)
                individual.validate
                expect(individual.errors).to_not include(:name)    
            end
            it 'it is invalid to have a email_id in incorrect fomrat' do
                individual=build(:individual, email_id: 'helloindi@')
                individual.validate
                expect(individual.errors).to include(:email_id)
            end

        end

        context 'contact number' do
            it 'valid contact number atleast minimum 10 numbers has no errors' do
            individual=build(:individual, contact_no: '9456712341')
            individual.validate
            expect(individual.errors).to_not include(:contact_no)
            end
        
            it 'a contact number with only 5 numbers is invalid' do
            individual=build(:individual,contact_no: '12345')
            individual.validate
            expect(individual.errors).to include(:contact_no)
            end
        
            it 'a contact number with alteast minimum 10 characters including other than numbers has no errors' do
            individual=build(:individual, contact_no: '123a123123')
            individual.validate
            expect(individual.errors).to include(:contact_no)
            end
        
            it 'a contact number with more than 15 characters(even only numbers) is invalid' do
            individual=build(:individual, contact_no: '123451234578901789')
            individual.validate
            expect(individual.errors).to include(:contact_no)
            end
        end
        
        context 'sslc percentage' do

            it 'it is invalid to have the sslc percentage nil' do
                individual=build(:individual, sslc_percentage: nil)
                individual.validate
                expect(individual.errors).to include(:sslc_percentage)    
            end
            it 'it is valid to have some number in sslc percentage' do
                individual=build(:individual)
                individual.validate
                expect(individual.errors).to_not include(:sslc_percentage)    
            end

        end

        context 'hsc/diplomo percentage' do

            it 'it is invalid to have the hsc/diplomo percentage nil' do
                individual=build(:individual, hsc_diplomo_percentage: nil)
                individual.validate
                expect(individual.errors).to include(:hsc_diplomo_percentage)    
            end
            it 'it is valid to have some number in hsc/diplomo percentage' do
                individual=build(:individual)
                individual.validate
                expect(individual.errors).to_not include(:hsc_diplomo_percentage)    
            end

        end

        context 'hsc/diplomo ' do

            it 'it is invalid to have the hsc/diplomo nil' do
                individual=build(:individual, hsc_diplomo: nil)
                individual.validate
                expect(individual.errors).to include(:hsc_diplomo)    
            end
            it 'it is invalid to have any other string than HSC/DIPLOMO as hsc/diplomo' do
                individual=build(:individual, hsc_diplomo: 'any thing other')
                individual.validate
                expect(individual.errors).to include(:hsc_diplomo)    
            end
            it 'it is valid to have some number in hsc/diplomo' do
                individual=build(:individual, hsc_diplomo: 'DIPLOMO')
                individual.validate
                expect(individual.errors).to_not include(:hsc_diplomo)    
            end

        end

        context 'user' do

            it 'checks the presence of a user' do
                individual=build(:individual, user: nil)
                individual.validate
                expect(individual.errors).to include(:user)
            end

            it 'checks the presence of a user' do
                individual=build(:individual)
                individual.validate
                expect(individual.errors).to_not include(:user)
            end
        end
    end

    describe 'associations of individual ' do
        context 'user' do
            it 'individual belongs to a user' do
                t=Individual.reflect_on_association(:user)
                expect(t.macro).to eq(:belongs_to)
            end
        end

        context 'individual application' do
            it 'individual has many individual applications' do 
                t=Individual.reflect_on_association(:individual_applications)
                expect(t.macro).to eq(:has_many)
            end
        end
        
        context 'jobs' do
            it 'individual has many jobs through individual applications' do
                t=Individual.reflect_on_association(:jobs)
                expect(t.macro).to eq(:has_many)
                expect(t.options[:through]).to eq(:individual_applications)
            end
        end

    end


end
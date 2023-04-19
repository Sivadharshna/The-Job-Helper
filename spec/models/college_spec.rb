require 'rails_helper' 

RSpec.describe College , type: :model do

      context 'valid name' do
        it 'Has error in presence of name when input is nil' do
          college=build(:college, name: '')
          college.validate
          expect(college.errors).to include(:name)
        end
        it 'Has no error in presence of name when input is some string' do
          college=build(:college)
          college.validate
          expect(college.errors).to_not include(:name)
        end    
      end
    
      context 'valid_email_id' do
        it 'Has error in email when email id is nil' do
          college=build(:college, email_id: '')
          college.validate
          expect(college.errors).to include(:email_id)
        end
    
        it 'Has error in email when email id is a valid string' do
          college=build(:college)
          college.validate
          expect(college.errors).to_not include(:email_id)
        end
    
        it 'has to throw an error when an invid mail id is entered' do
          college=build(:college, email_id: 'helolworld' )
          college.validate
          expect(college.errors).to include(:email_id)
        end
        
      end
    
      context 'valid contact number' do
        it 'valid contact number atleast minimum 10 numbers has no errors' do
          college=build(:college, contact_no: '9456712341')
          college.validate
          expect(college.errors).to_not include(:contact_no)
        end
    
        it 'a contact number with only 5 numbers is invalid' do
          college=build(:college,contact_no: '12345')
          college.validate
          expect(college.errors).to include(:contact_no)
        end
    
        it 'a contact number with alteast minimum 10 characters including other than numbers has no errors' do
          college=build(:college, contact_no: '123a123123')
          college.validate
          expect(college.errors).to include(:contact_no)
        end
    
        it 'a contact number with more than 15 characters(even only numbers) is invalid' do
          college=build(:college, contact_no: '123451234578901789')
          college.validate
          expect(college.errors).to include(:contact_no)
        end
    end

    context 'valid user' do

        it 'checks the presence of a user' do
            college=build(:college, user: nil)
            college.validate
            expect(college.errors).to include(:user)
        end

        it 'checks the presence of a user' do
            college=build(:college)
            college.validate
            expect(college.errors).to_not include(:user)
        end
    end

    context 'valid address' do
        it 'Has error in presence of name when input is nil' do
          college=build(:college, address: '')
          college.validate
          expect(college.errors).to include(:address)
        end
        it 'Has no error in presence of name when input is some string' do
          college=build(:college)
          college.validate
          expect(college.errors).to_not include(:address)
        end    
    end

    describe 'associations for college' do
      context 'user' do
        it 'belongs to a user' do
            t = College.reflect_on_association(:user)
            expect(t.macro).to eq(:belongs_to)
        end
      end

      context 'college_applications' do
        it 'college has many college applications' do
            t=College.reflect_on_association(:college_applications)
            expect(t.macro).to eq(:has_many)
        end
      end

      context 'company' do
          it 'college has many companies through college applications ' do
              t=College.reflect_on_association(:companies)
              expect(t.macro).to eq(:has_many)
              expect(t.options[:through]).to eq(:college_applications)
          end
      end

      context 'course' do
        it 'college has many courses' do
            t=College.reflect_on_association(:courses)
            expect(t.macro).to eq(:has_many)
        end
      end


    end

end
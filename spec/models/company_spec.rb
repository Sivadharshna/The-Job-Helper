require 'rails_helper'

RSpec.describe Company, type: :model do
  
  describe 'validations of company' do 
    context 'name' do
      it 'Has error in presence of name when input is nil' do
        company=build(:company, name: '')
        company.validate
        expect(company.errors).to include(:name)
      end
      it 'Has no error in presence of name when input is some string' do
        company=build(:company)
        company.validate
        expect(company.errors).to_not include(:name)
      end    
    end

    context 'email_id' do
      it 'Has error in email when email id is nil' do
        company=build(:company, email_id: '')
        company.validate
        expect(company.errors).to include(:email_id)
      end

      it 'Has error in email when email id is a valid string' do
        company=build(:company)
        company.validate
        expect(company.errors).to_not include(:email_id)
      end

      it 'has to throw an error when an invid mail id is entered' do
        company=build(:company, email_id: 'helolworld' )
        company.validate
        expect(company.errors).to include(:email_id)
      end
      
    end

    context 'contact number' do
      it 'valid contact number atleast minimum 10 numbers has no errors' do
        company=build(:company, contact_no: '9456712341')
        company.validate
        expect(company.errors).to_not include(:contact_no)
      end

      it 'a contact number with only 5 numbers is invalid' do
        company=build(:company,contact_no: '12345')
        company.validate
        expect(company.errors).to include(:contact_no)
      end

      it 'a contact number with alteast minimum 10 characters including other than numbers has no errors' do
        company=build(:company, contact_no: '123a123123')
        company.validate
        expect(company.errors).to include(:contact_no)
      end

      it 'a contact number with more than 15 characters(even only numbers) is invalid' do
        company=build(:company, contact_no: '123451234578901789')
        company.validate
        expect(company.errors).to include(:contact_no)
      end
    end
  end

  describe 'foreign key' do
    context 'user' do
      it 'company should be hold by an user, if not then false' do
        company=build(:company, user_id: '' )
        company.validate
        expect(company.errors).to include(:user)
      end

      it 'company should be hold by an user, if yes then true' do
        company=build(:company)
        company.validate
        expect(company.errors).to_not include(:user)
      end

    end
  end

  describe 'associations of company' do
    context 'user' do
      it 'company belongs to a user' do
        t = Company.reflect_on_association(:user)
        expect(t.macro).to eq(:belongs_to)
      end
    end

    context 'college_applications' do
      it 'company has many college applications' do
          t=Company.reflect_on_association(:college_applications)
          expect(t.macro).to eq(:has_many)
      end
    end

    context 'colleges' do
        it 'company has many colleges through college applications ' do
            t=Company.reflect_on_association(:colleges)
            expect(t.macro).to eq(:has_many)
            expect(t.options[:through]).to eq(:college_applications)
        end
    end
  end

  describe 'callbacks' do
    context 'remove trailing spaces' do
      it 'should remove the trailing spaces before validations ' do
        company=build(:company , name: ' Google  India ', email_id: ' siva15@gmail.com ', contact_no: '  1234567891 ' , address: ' 123, delhi,   India' )
        company.validate
        expect(company.name).to eq('Google India')
        expect(company.email_id).to eq('siva15@gmail.com')
        expect(company.contact_no).to eq('1234567891')
        expect(company.address).to eq('123, delhi, India')
      end
    end
  end

end

require 'rails_helper' 

RSpec.describe User, type: :model do
    
    context 'associations' do

        it "user has one permisssion" do
            t = User.reflect_on_association(:permission)
            expect(t.macro).to eq(:has_one)
        end

        it "user has one college" do
            t = User.reflect_on_association(:college)
            expect(t.macro).to eq(:has_one)
        end

        it "user has one company" do
            t = User.reflect_on_association(:company)
            expect(t.macro).to eq(:has_one)
        end

        it 'user has one individual' do
            t = User.reflect_on_association(:individual)
            expect(t.macro).to eq(:has_one)
        end

        it 'belongs to a user' do
            t = User.reflect_on_association(:college)
            expect(t.macro).to eq(:has_one)
        end

    end

end

require 'rails_helper'

RSpec.describe Student, type: :model do
    
    describe 'default for' do
        it 'default value for status' do
            permission=build(:permission)
            permission.validate
            expect(permission.status).to eq('Yet to be approved')
        end
    end

    describe 'associations for permission' do
        context 'user' do
            it 'permission belongs to user' do
                t=Permission.reflect_on_association(:user)
                expect(t.macro).to eq(:belongs_to)
            end
        end
    end

end
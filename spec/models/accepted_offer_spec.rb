require 'rails_helper'

RSpec.describe AcceptedOffer, type: :model do
    
    describe 'associations for accepted offer' do
        context 'individual application' do
            it 'accepted offer belongs to individual application' do
                t=AcceptedOffer.reflect_on_association(:approval)
                expect(t.macro).to eq(:belongs_to)
                expect(t.options[:polymorphic]).to eq(true)
            end
        end
    end


end
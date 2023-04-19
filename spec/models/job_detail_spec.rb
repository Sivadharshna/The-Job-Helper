require 'rails_helper' 

RSpec.describe College , type: :model do

    describe 'associations for job details' do
        context 'accepted_offer' do
            it 'job details belongs to accepted offer' do
                t=JobDetail.reflect_on_association(:accepted_offer)
                expect(t.macro).to eq(:belongs_to)
            end
        end
    end
end
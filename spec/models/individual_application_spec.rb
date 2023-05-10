require 'rails_helper'

RSpec.describe IndividualApplication, type: :model do

    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}


    describe 'Default value' do
        context 'for status' do
            it 'checks whether the default attribut is set' do
                individual=create(:individual,user: user3)
                iappl=build(:individual_application, individual: individual)
                #iappl.validate
                expect(iappl.status).to eq('Under Progress')
            end
        end

    end
    

    describe 'associations for individual application' do
        context 'individual' do
            it 'individual applications belongs to individuals' do
                t=IndividualApplication.reflect_on_association(:individual)
                expect(t.macro).to eq(:belongs_to)
            end
        end
        context 'job' do
            it 'individual applications belongs to jobs' do
                t=IndividualApplication.reflect_on_association(:job)
                expect(t.macro).to eq(:belongs_to)
            end
        end

        context 'accepted offer' do
            it 'accepted offer has one accepted offer' do
                t=IndividualApplication.reflect_on_association(:accepted_offer)
                expect(t.macro).to eq(:has_one)
            end
        end

        context 'job_details' do
            it 'individual applications has one job detail through accepted_offer' do
                t=IndividualApplication.reflect_on_association(:job_detail)
                expect(t.macro).to eq(:has_one)
                expect(t.options[:through]).to eq(:accepted_offer)
            end
        end
    end
end
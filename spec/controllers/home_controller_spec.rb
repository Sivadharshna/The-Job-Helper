require 'rails_helper'

RSpec.describe HomeController , type: :controller do
    let!(:user1) { create(:user, role: 'company') }
    let!(:user2) { create(:user,email: 'college@example.com', role: 'college') }
    let!(:user3) { create(:user, email: 'individual@example.com' , role: 'individual')}
    let!(:company1) { create(:company , user: user1) }
    let!(:college2) { create(:college, user: user2) }
    let!(:individual3) { create(:individual, user: user3 )}

    describe 'Renering home pages based on user' do
        context 'after signing in' do
            it 'as company' do
                sign_in user1 
                if company1==nil
                    expect(response).to redirect_to('/companies/new')
                else
                    expect(response).to render_template(nil)
                end
            end

            it 'as college' do
                sign_in user2
                if college2==nil
                    expect(response).to redirect_to('/colleges/new')
                else
                    expect(response).to render_template(nil)
                end
            end

            it 'as individual' do
                sign_in user3
                if individual3==nil
                    expect(response).to redirect_to('/colleges/new')
                else
                    expect(response).to render_template(nil)
                end
            end
        end

        context 'before signing in' do
            it 'shows the home page ' do
                expect(response).to render_template(nil)
            end
        end
    end
end
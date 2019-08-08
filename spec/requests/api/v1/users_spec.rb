require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  
  describe 'GET /api/users/:id' do
    before do
      header = { 'Accept' => 'application/vnd.taskmanager.v1' }
      get "/api/users/#{user_id}", params: {}, headers: header
    end
    
    context 'when the user exists' do
      it 'returns the user' do
        user_response = JSON.parse(response.body)
        expect(user_response['id']).to eq(user_id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the user dont exists' do
      let(:user_id) { User.count + 1 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end

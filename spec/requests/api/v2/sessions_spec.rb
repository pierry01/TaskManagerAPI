require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  let(:user) { create(:user) }
  
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s
    }
  end
  
  describe 'POST /api/sessions' do
    before { post '/api/sessions', params: { session: credentials }.to_json, headers: headers }
  
    context 'When the credentials are correct' do
      let(:credentials) { { email: user.email, password: 123456 } }
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns JSON data for the user with auth token' do
        user.reload
        expect(json_body[:data][:attributes][:auth_token]).to eq(user.auth_token)
      end
    end
    
    context 'When the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'INVÁLIDO' } }
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
      
      it 'returns JSON data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
  
  describe 'DELETE /api/sessions/:id' do
    let(:auth_token) { user.auth_token }
    
    before { delete "/api/sessions/#{auth_token}", params: {}, headers: headers }
    
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
    
    it 'changes the user auth_token' do
      expect(User.find_by(auth_token: auth_token)).to be_nil
    end
  end
end

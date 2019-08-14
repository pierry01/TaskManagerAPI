require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end
  
  describe 'GET /api/users/:id' do
    before { get "/api/users/#{user_id}", params: {}, headers: headers }
    
    context 'when the user exists' do
      it 'returns the user' do
        expect(json_body[:id]).to eq(user_id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the user dont exists' do
      let(:user_id) { 100 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'POST /api/users' do
    before { post '/api/users', params: { user: user_params }.to_json, headers: headers }
    
    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }
      
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      
      it 'returns json data for created user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end
    
    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid_email') }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns json data for error' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
  
  describe 'PUT /api/users/:id' do
    before { put "/api/users/#{user_id}", params: { user: user_params }.to_json, headers: headers }
    
    context 'when the request params are valid' do
      let(:user_params) { { email: 'new_email@taskmanager.com' } }
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns json data for updated user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end
    
    context 'when the request params are invalid' do
      let(:user_params) { { email: 'invalid_email' } }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns json data for error' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
  
  describe 'DELETE /api/users/:id' do
    before { delete "/api/users/#{user_id}", params: {}, headers: headers }
    
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
    
    it 'removes user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end

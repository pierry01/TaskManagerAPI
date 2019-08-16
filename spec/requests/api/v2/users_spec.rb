require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end
  
  describe 'GET /auth/validate_token' do
    context 'when the request headers are valid' do
      before { get '/auth/validate_token', params: {}, headers: headers }
      
      it 'returns the user id' do
        expect(json_body[:data][:id].to_i).to eq(user.id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the request headers are invalid' do
      before do
        headers['access-token'] = 'INVALID_TOKEN'
        get '/auth/validate_token', params: {}, headers: headers
      end
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
  
  describe 'POST /auth' do
    before { post '/auth', params: user_params.to_json, headers: headers }
    
    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns json data for created user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
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
  
  describe 'PUT /auth' do
    before { put '/auth', params: user_params.to_json, headers: headers }
    
    context 'when the request params are valid' do
      let(:user_params) { { email: 'new_email@taskmanager.com' } }
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns json data for updated user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
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
  
  describe 'DELETE /auth' do
    before { delete '/auth', params: {}, headers: headers }
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it 'removes user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end

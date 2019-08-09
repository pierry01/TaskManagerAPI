require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  
  describe 'GET /api/users/:id' do
    before do
      headers = { 'Accept' => 'application/vnd.taskmanager.v1' }
      get "/api/users/#{user_id}", params: {}, headers: headers
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
      let(:user_id) { User.all.count + 1 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'POST /api/users' do
    before do
      headers = { 'Accept' => 'application/vnd.taskmanager.v1' }
      post '/api/users', params: { user: user_params }, headers: headers
    end
    
    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }
      
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      
      it 'returns json data for created user' do
        user_response = JSON.parse(response.body)
        expect(user_response['email']).to eq(user_params[:email])
      end
    end
    
    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid_email') }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns json data for error' do
        user_response = JSON.parse(response.body)
        expect(user_response).to have_key('errors')
      end
    end
  end
end

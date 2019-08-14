require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Accept' => 'application/vnd.taskmanager.v2',
      'Authorization' => user.auth_token
    }
  end
  
  describe 'GET /api/tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/api/tasks', params: {}, headers: headers
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it 'returns 5 tasks from database' do
      expect(json_body[:data].count).to eq (5)
    end
  end
  
  describe 'GET /api/tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }
    
    before { get "/api/tasks/#{task.id}", params: {}, headers: headers }
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for task' do
      expect(json_body[:data][:attributes][:title]).to eq(task.title)
    end
  end
  
  describe 'POST /api/tasks' do
    before { post '/api/tasks', params: { task: task_params }.to_json, headers: headers }
    
    context 'when the request params are valid' do
      let(:task_params) { attributes_for(:task) }
      
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      
      it 'saves the task in the database' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end
      
      it 'returns the json for created task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end

      it 'assigns the created task to the current user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end
    
    context 'when the request params are invalid' do
      let(:task_params) { attributes_for(:task, title: nil) }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'doest not save the task in the database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end

      it 'returns the json errors for title' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end
  
  describe 'PUT /api/tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }
    
    before { put "/api/tasks/#{task.id}", params: { task: task_params }.to_json, headers:headers }
    
    context 'when the params are valid' do
      let(:task_params) { { title: 'New task title' } }
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the json for updated task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end
      
      it 'updates the task in the database' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end
    end
    
    context 'when the params are invalid' do
      let(:task_params) { { title: nil } }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns the json error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end
      
      it 'does not updates the task in the database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end
    end
  end
  
  describe 'DELETE /api/tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }
    
    before { delete "/api/tasks/#{task.id}", params: {}, headers: headers }
    
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
    
    it 'removes the task from the database' do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let(:genre) { Genre.create!(name: 'テストジャンル') }

  describe 'POST /tasks' do
    context 'priorityパラメータを指定した場合' do
      it 'priorityを指定してタスクを作成できること' do
        params = {
          name: 'テストタスク',
          explanation: 'テスト説明',
          genreId: genre.id,
          priority: 'high'
        }

        expect {
          post '/tasks', params: params
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:ok)

        created_task = Task.last
        expect(created_task.priority).to eq 'high'
      end

      it 'レスポンスJSONに作成されたタスクのpriorityが含まれること' do
        params = {
          name: 'テストタスク',
          explanation: 'テスト説明',
          genreId: genre.id,
          priority: 'low'
        }

        post '/tasks', params: params

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        created_task_json = json_response.find { |task| task['name'] == 'テストタスク' }

        expect(created_task_json).to include('priority')
        expect(created_task_json['priority']).to eq 'low'
      end
    end

    context 'priorityパラメータを指定しない場合' do
      it 'デフォルト値(medium)でタスクが作成されること' do
        params = {
          name: 'デフォルトpriorityタスク',
          explanation: 'テスト説明',
          genreId: genre.id
        }

        post '/tasks', params: params

        expect(response).to have_http_status(:ok)

        created_task = Task.last
        expect(created_task.priority).to eq 'medium'
      end

      it 'レスポンスJSONにデフォルトのpriorityが含まれること' do
        params = {
          name: 'デフォルトpriorityタスク',
          explanation: 'テスト説明',
          genreId: genre.id
        }

        post '/tasks', params: params

        json_response = JSON.parse(response.body)
        created_task_json = json_response.find { |task| task['name'] == 'デフォルトpriorityタスク' }

        expect(created_task_json['priority']).to eq 'medium'
      end
    end
  end
end

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

  describe 'POST /tasks/:id/duplicate' do
    let(:original_task) do
      Task.create!(
        name: '元のタスク',
        explanation: 'タスクの説明文',
        genre: genre,
        priority: :high,
        status: :in_progress,
        deadline_date: '2026-12-31'
      )
    end

    context '正常系' do
      it 'ステータス200を返すこと' do
        post "/tasks/#{original_task.id}/duplicate"

        expect(response).to have_http_status(:ok)
      end

      it 'リクエスト後、Task レコードが1つ増えること' do
        original_task # let を事前に評価

        expect {
          post "/tasks/#{original_task.id}/duplicate"
        }.to change(Task, :count).by(1)
      end

      it 'レスポンスが全タスク一覧形式（配列）で返されること' do
        post "/tasks/#{original_task.id}/duplicate"

        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
      end

      it 'レスポンスのContent-Typeが application/json であること' do
        post "/tasks/#{original_task.id}/duplicate"

        expect(response.content_type).to include('application/json')
      end

      it 'レスポンスJSONに複製されたタスクが含まれること' do
        post "/tasks/#{original_task.id}/duplicate"

        json_response = JSON.parse(response.body)
        duplicated = json_response.find { |task| task['name'] == '元のタスク（コピー）' }

        expect(duplicated).not_to be_nil
      end
    end

    context '異常系' do
      it '存在しないIDでリクエストすると404を返すこと' do
        post '/tasks/99999/duplicate'

        expect(response).to have_http_status(:not_found)
      end

      it '存在しないIDでリクエストすると Task レコード数が変わらないこと' do
        expect {
          post '/tasks/99999/duplicate'
        }.not_to change(Task, :count)
      end
    end

    context 'HTTPメソッド' do
      it 'GET /tasks/:id/duplicate は duplicate アクションとして処理されないこと' do
        original_task # let を事前に評価

        expect {
          get "/tasks/#{original_task.id}/duplicate"
        }.not_to change(Task, :count)
      end
    end
  end

  describe 'GET /tasks/report' do
    context 'タスクが存在しない場合' do
      it '正常なレスポンスを返すこと' do
        get '/tasks/report'

        expect(response).to have_http_status(:ok)
      end

      it '統計情報を返すこと' do
        get '/tasks/report'

        json = JSON.parse(response.body)
        expect(json['totalCount']).to eq(0)
        expect(json['countByStatus']).to eq(
          'notStarted' => 0,
          'inProgress' => 0,
          'completed' => 0
        )
        expect(json['completionRate']).to eq(0.0)
      end
    end

    context 'タスクが存在する場合' do
      before do
        Task.create!(name: 'タスク1', genre: genre, status: :not_started)
        Task.create!(name: 'タスク2', genre: genre, status: :not_started)
        Task.create!(name: 'タスク3', genre: genre, status: :in_progress)
        Task.create!(name: 'タスク4', genre: genre, status: :completed)
      end

      it '正しい統計情報を返すこと' do
        get '/tasks/report'

        json = JSON.parse(response.body)
        expect(json['totalCount']).to eq(4)
        expect(json['countByStatus']).to eq(
          'notStarted' => 2,
          'inProgress' => 1,
          'completed' => 1
        )
        expect(json['completionRate']).to eq(25.0)
      end
    end

    context '完了率の端数処理' do
      before do
        Task.create!(name: 'タスク1', genre: genre, status: :not_started)
        Task.create!(name: 'タスク2', genre: genre, status: :completed)
        Task.create!(name: 'タスク3', genre: genre, status: :completed)
      end

      it '小数点以下1桁のパーセンテージで返すこと' do
        get '/tasks/report'

        json = JSON.parse(response.body)
        expect(json['completionRate']).to eq(66.7)
      end
    end
  end
end

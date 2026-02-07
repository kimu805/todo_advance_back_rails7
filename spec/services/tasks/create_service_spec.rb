require 'rails_helper'

RSpec.describe Tasks::CreateService do
  let(:genre) { Genre.create!(name: 'テストジャンル') }

  describe '.call' do
    context '有効なパラメータの場合' do
      let(:params) do
        {
          name: 'テストタスク',
          explanation: 'タスクの説明',
          genreId: genre.id,
          deadlineDate: '2026-12-31',
          priority: 'high',
          status: 1
        }
      end

      it '成功結果を返すこと' do
        result = described_class.call(params)

        expect(result.success?).to be true
        expect(result.failure?).to be false
      end

      it 'Task を作成すること' do
        expect {
          described_class.call(params)
        }.to change(Task, :count).by(1)
      end

      it '作成された Task を返すこと' do
        result = described_class.call(params)
        task = result.data

        expect(task).to be_a(Task)
        expect(task).to be_persisted
        expect(task.name).to eq('テストタスク')
        expect(task.explanation).to eq('タスクの説明')
        expect(task.genre_id).to eq(genre.id)
        expect(task.deadline_date).to eq(Date.parse('2026-12-31'))
        expect(task.priority).to eq('high')
        expect(task.status).to eq(1)
      end

      it 'camelCase パラメータを snake_case に変換すること' do
        result = described_class.call(params)
        task = result.data

        expect(task.genre_id).to eq(genre.id)
        expect(task.deadline_date).to eq(Date.parse('2026-12-31'))
      end
    end

    context 'priority が指定されていない場合' do
      let(:params) do
        {
          name: 'デフォルトpriorityタスク',
          genreId: genre.id
        }
      end

      it 'デフォルト値(medium)で作成されること' do
        result = described_class.call(params)
        task = result.data

        expect(task.priority).to eq('medium')
      end
    end

    context '無効なパラメータの場合' do
      context 'genre_id が存在しない場合' do
        let(:params) do
          {
            name: 'テストタスク',
            genreId: 99999
          }
        end

        it '失敗結果を返すこと' do
          result = described_class.call(params)

          expect(result.failure?).to be true
          expect(result.errors).not_to be_empty
        end

        it 'Task を作成しないこと' do
          expect {
            described_class.call(params)
          }.not_to change(Task, :count)
        end
      end
    end

    context '許可されていないパラメータが含まれる場合' do
      let(:params) do
        {
          name: 'テストタスク',
          genreId: genre.id,
          malicious_param: 'malicious_value',
          admin: true
        }
      end

      it '許可されたパラメータのみで Task を作成すること' do
        result = described_class.call(params)
        task = result.data

        expect(task.name).to eq('テストタスク')
        expect(task).not_to respond_to(:malicious_param)
      end
    end
  end
end

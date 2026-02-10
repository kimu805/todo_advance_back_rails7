require 'rails_helper'

RSpec.describe Tasks::ReportService do
  let(:genre) { Genre.create!(name: 'テストジャンル') }

  describe '.call' do
    context 'タスクが存在しない場合' do
      it '成功すること' do
        result = described_class.call

        expect(result).to be_success
      end

      it 'totalCount が 0 であること' do
        result = described_class.call

        expect(result.data[:total_count]).to eq(0)
      end

      it 'countByStatus が全て 0 であること' do
        result = described_class.call

        expect(result.data[:count_by_status]).to eq(
          not_started: 0,
          in_progress: 0,
          completed: 0
        )
      end

      it 'completionRate が 0.0 であること' do
        result = described_class.call

        expect(result.data[:completion_rate]).to eq(0.0)
      end
    end

    context 'タスクが存在する場合' do
      before do
        Task.create!(name: 'タスク1', genre: genre, status: :not_started)
        Task.create!(name: 'タスク2', genre: genre, status: :not_started)
        Task.create!(name: 'タスク3', genre: genre, status: :in_progress)
        Task.create!(name: 'タスク4', genre: genre, status: :completed)
      end

      it '成功すること' do
        result = described_class.call

        expect(result).to be_success
      end

      it 'totalCount が正しいこと' do
        result = described_class.call

        expect(result.data[:total_count]).to eq(4)
      end

      it 'countByStatus が正しいこと' do
        result = described_class.call

        expect(result.data[:count_by_status]).to eq(
          not_started: 2,
          in_progress: 1,
          completed: 1
        )
      end

      it 'completionRate が正しいこと' do
        result = described_class.call

        expect(result.data[:completion_rate]).to eq(25.0)
      end
    end

    context '完了率の小数点計算' do
      before do
        Task.create!(name: 'タスク1', genre: genre, status: :not_started)
        Task.create!(name: 'タスク2', genre: genre, status: :completed)
        Task.create!(name: 'タスク3', genre: genre, status: :completed)
      end

      it '小数点以下1桁で丸められること' do
        result = described_class.call

        expect(result.data[:completion_rate]).to eq(66.7)
      end
    end
  end
end

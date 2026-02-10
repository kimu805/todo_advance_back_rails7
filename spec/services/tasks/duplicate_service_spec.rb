require 'rails_helper'

RSpec.describe Tasks::DuplicateService do
  let(:genre) { Genre.create!(name: 'テストジャンル') }
  let(:original_task) do
    Task.create!(
      name: '元のタスク',
      explanation: 'タスクの説明文',
      genre: genre,
      priority: :medium,
      status: 0,
      deadline_date: '2026-12-31'
    )
  end

  describe '.call' do
    context '属性の引き継ぎ' do
      it 'name が引き継がれ、末尾に「（コピー）」が付与されること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.name).to eq('元のタスク（コピー）')
      end

      it 'explanation がそのまま引き継がれること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.explanation).to eq('タスクの説明文')
      end

      it 'genre_id がそのまま引き継がれること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.genre_id).to eq(genre.id)
      end

      it 'priority がそのまま引き継がれること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.priority).to eq('medium')
      end
    end

    context '特別な処理' do
      it 'コピー元が進行中でも status が未着手（初期ステータス）になること' do
        original_task.update!(status: 1)

        result = described_class.call(original_task)
        task = result.data

        expect(task.status).to eq(0)
      end

      it 'コピー元が完了でも status が未着手（初期ステータス）になること' do
        original_task.update!(status: 2)

        result = described_class.call(original_task)
        task = result.data

        expect(task.status).to eq(0)
      end

      it 'コピー元に deadline_date があっても nil になること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.deadline_date).to be_nil
      end

      it 'コピー元の deadline_date が nil でも nil のままであること' do
        original_task.update!(deadline_date: nil)

        result = described_class.call(original_task)
        task = result.data

        expect(task.deadline_date).to be_nil
      end
    end

    context '新規レコードとしての生成' do
      it 'コピー元とは異なる id を持つこと' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.id).not_to eq(original_task.id)
      end

      it '永続化されていること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task).to be_persisted
      end

      it 'Task の総数が1つ増えること' do
        original_task # let を事前に評価

        expect {
          described_class.call(original_task)
        }.to change(Task, :count).by(1)
      end

      it 'created_at / updated_at がコピー元と異なること' do
        result = described_class.call(original_task)
        task = result.data

        expect(task.created_at).not_to eq(original_task.created_at)
      end
    end

    context 'name のエッジケース' do
      it 'name が空文字の場合「（コピー）」になること' do
        original_task.update_column(:name, '')

        result = described_class.call(original_task)
        task = result.data

        expect(task.name).to eq('（コピー）')
      end

      it 'name が既に「（コピー）」で終わっている場合、さらに「（コピー）」が追加されること' do
        original_task.update!(name: 'タスク（コピー）')

        result = described_class.call(original_task)
        task = result.data

        expect(task.name).to eq('タスク（コピー）（コピー）')
      end
    end

    context 'priority の各値テスト' do
      it 'priority が low のタスクを複製すると low が引き継がれること' do
        original_task.update!(priority: :low)

        result = described_class.call(original_task)
        task = result.data

        expect(task.priority).to eq('low')
      end

      it 'priority が high のタスクを複製すると high が引き継がれること' do
        original_task.update!(priority: :high)

        result = described_class.call(original_task)
        task = result.data

        expect(task.priority).to eq('high')
      end
    end

    context '正常系' do
      it '成功結果を返すこと' do
        result = described_class.call(original_task)

        expect(result.success?).to be true
        expect(result.failure?).to be false
      end

      it '複製された Task オブジェクトを返すこと' do
        result = described_class.call(original_task)

        expect(result.data).to be_a(Task)
      end
    end

  end
end

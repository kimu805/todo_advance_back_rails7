require 'rails_helper'

RSpec.describe ServiceResult do
  describe '.success' do
    it '成功状態の結果オブジェクトを返すこと' do
      data = { id: 1, name: 'test' }
      result = described_class.success(data)

      expect(result.success?).to be true
      expect(result.failure?).to be false
      expect(result.data).to eq(data)
      expect(result.errors).to eq([])
    end

    it 'データなしでも成功状態を返せること' do
      result = described_class.success

      expect(result.success?).to be true
      expect(result.data).to be_nil
    end
  end

  describe '.failure' do
    it '失敗状態の結果オブジェクトを返すこと' do
      errors = ['Name is required', 'Genre is required']
      result = described_class.failure(errors)

      expect(result.success?).to be false
      expect(result.failure?).to be true
      expect(result.data).to be_nil
      expect(result.errors).to eq(errors)
    end

    it '単一のエラーを配列に変換すること' do
      result = described_class.failure('Name is required')

      expect(result.errors).to eq(['Name is required'])
    end
  end
end

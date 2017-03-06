require 'spec_helper'

describe Proteus::ApiEntity do
  context 'when attributes are nil' do
    it 'throws an error' do
      expect { Proteus::ApiEntity.new(nil) }.to raise_error Proteus::ApiEntityError::EntityNotFound
    end
  end

  context 'when attributes are set' do
    let(:api_entitiy) do
      Proteus::ApiEntity.new(id: '12345', name: 'foobar', type: 'Thing', properties: 'foo=bar|baz=biz|buz=boz')
    end

    subject(:stringified) do
      'id: 12345 | name: foobar | type: Thing | properties: {:foo=>"bar", :baz=>"biz", :buz=>"boz"}'
    end

    describe '#inspect' do
      it 'returns a inspection string' do
        expect(api_entitiy.inspect).to eq(stringified)
      end
    end

    describe '#to_s' do
      it 'returns a stringified verison' do
        expect(api_entitiy.to_s).to eq(stringified)
      end
    end
  end
end

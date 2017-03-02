require 'spec_helper'

describe Proteus::Helpers do

  include Proteus::Helpers

  context 'when receiving nil' do
    describe '.decompose' do
      it 'returns nil' do
        expect(decompose nil).to be_nil
      end
    end

    describe '.compose' do
      it 'returns nil' do
        expect(compose nil).to be_nil
      end
    end
  end

  context 'when receiving valid arguments' do
    subject(:prop_string) { 'foo=bar|baz=biz|boz=buz' }
    subject(:prop_hash) { { foo: 'bar', baz: 'biz', boz: 'buz' } }
    describe '.decompose' do
      it 'returns the correct properties hash' do
        expect(decompose prop_string).to eq(prop_hash)
      end
    end

    describe '.compose' do
      it 'returns the correct properties string' do
        expect(compose prop_hash).to eq(prop_string)
      end
    end
  end

  describe '.normalize' do
    describe '.normalize' do
      it 'returns an empty Array' do
        expect(normalize nil).to eq(Array.new)
      end
    end

    context 'when receiving single item' do
      subject(:item_hash) { { item: { foo: 'bar', baz: 'biz', boz: 'buz' }} }
      it 'returns a normalized hash' do
        expect(normalize item_hash).to eq([item_hash[:item]])
      end
    end

    context 'when receiving a list of items' do
      subject(:item_hash) { { item: [{ foo: 'bar', baz: 'biz' }, { zap: 'zip', zop: 'zup' }] } }
      it 'returns a normalized hash' do
        expect(normalize item_hash).to eq(item_hash[:item])
      end
    end
  end
end

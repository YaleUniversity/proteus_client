require 'spec_helper'

describe Proteus::Client do

  include Savon::SpecHelper

  before(:all) { savon.mock! }
  before(:each) {
    wsdl = File.read('spec/fixtures/proteus.wsdl')
    stub_request(:get, /\/Services\/API\?wsdl/).to_return(:status => 200, :body => wsdl)
  }
  after(:all)  { savon.unmock! }

  describe '#login!' do
    it 'logs into proteus' do
      options = {
          'user' => 'like',
          'password' => 'aboss',
          'url' => 'https://localhost'
      }

      message = { username: options['user'], password: options['password'] }
      fixture = File.read('spec/fixtures/client/login.xml')

      savon.expects(:login).with(message: message).returns(fixture)

      client = Proteus::Client.new(options, 'debug')
      response = client.login!

      expect(response).to eq([])
    end
  end

  describe '#logout!' do
    it 'logs out of proteus' do
      options = {
          'user' => 'like',
          'password' => 'aboss',
          'url' => 'https://localhost'
      }

      fixture = File.read('spec/fixtures/client/logout.xml')

      savon.expects(:logout).returns(fixture)

      client = Proteus::Client.new(options, 'debug')
      response = client.logout!

      expect(response).to be_successful
    end
  end
end

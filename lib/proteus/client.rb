# Module to hold Proteus related classes
module Proteus
  # Class to describe a Proteus client
  class Client
    require 'logger'
    require 'savon'

    include Proteus::Actions
    include Proteus::Helpers

    attr_accessor :user, :password, :view_id

    # Initialize a proteus [soap] client.  Expect the options hash to contain:
    # user, password, default_viewid, url
    def initialize(options = {}, log_level = 'warn')
      @logger = Logger.new(STDOUT)
      @logger.level = Object.const_get("Logger::#{log_level.upcase}")

      @user = options['user']
      @password = options['password']
      @view_id = options['default_viewid']

      @client = Savon.client do
        wsdl "#{options['url']}/Services/API?wsdl"
        ssl_verify_mode :none
        log true
        log_level log_level.to_sym
      end

      @cookies = login!
    end

    # login to proteus api and return authorization cookie
    # <message name="ProteusAPI_login">
    #   <part name="username" type="xsd:string"/>
    #   <part name="password" type="xsd:string"/>
    # </message>
    def login!
      @client.call(:login, message: { username: @user, password: @password }).http.cookies
    end

    # logout of proteus api
    # <message name="ProteusAPI_logout"/>
    def logout!
      @client.call(:logout) { |ctx| ctx.cookies @cookies }
    end
  end
end

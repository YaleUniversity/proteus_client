module Proteus
  ##
  # Class to describe a Proteus client object
  class Client
    require 'logger'
    require 'savon'

    include Proteus::Actions
    include Proteus::Helpers

    attr_accessor :user, :password, :view_id

    ##
    # Initialize a proteus [soap] client.  Expect the options hash to contain:
    # user, password, default_viewid, url
    def initialize(options = {})
      loglevel = options[:loglevel] || 'warn'
      @logger = options[:logger] || Logger.new(STDOUT)
      @logger.level = Object.const_get("Logger::#{loglevel.upcase}")
      @logger.debug("Configuring proteus client with #{options.inspect}")

      @username = options[:username]
      @password = options[:password]
      @view_id = options[:viewid] || 0

      @client = Savon.client do
        wsdl "#{options[:url]}/Services/API?wsdl"
        ssl_verify_mode :none
        log true
        log_level loglevel.to_sym
      end
    end

    ##
    # Login to the proteus api and return an authorization cookie
    #   <message name="ProteusAPI_login">
    #     <part name="username" type="xsd:string"/>
    #     <part name="password" type="xsd:string"/>
    #   </message>
    def login!
      @cookies = @client.call(:login, message: { username: @username, password: @password }).http.cookies
      self
    end

    ##
    # Logout of the proteus api
    #   <message name="ProteusAPI_logout"/>
    def logout!
      @client.call(:logout) { |ctx| ctx.cookies @cookies }
    end
  end
end

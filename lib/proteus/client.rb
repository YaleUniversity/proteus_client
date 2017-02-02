# Module to hold Proteus related classes
module Proteus
  # Class to describe a Proteus client
  class Client
    require 'logger'
    require 'savon'

    attr_accessor :user, :password, :view_id

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
      @client.call(:login, message: { username: @user,
                                      password: @password }).http.cookies
    end

    # add host record
    # <message name="ProteusAPI_addHostRecord">
    #   <part name="viewId" type="xsd:long"/>
    #   <part name="absoluteName" type="xsd:string"/>
    #   <part name="addresses" type="xsd:string"/>
    #   <part name="ttl" type="xsd:long"/>
    #   <part name="properties" type="xsd:string"/>
    # </message>
    def add_host_record(fqdn, ip, ttl = -1, properties = '')
      response = @client.call(:add_host_record) do |ctx|
        ctx.cookies @cookies
        ctx.message viewId: @view_id, absoluteName: fqdn, addresses: ip,
                    ttl: ttl, properties: properties
      end
      @logger.debug("add_host_record: #{response.body.inspect}")
      response.body
    end

    # add alias record
    # <message name="ProteusAPI_addAliasRecord">
    #   <part name="viewId" type="xsd:long"/>
    #   <part name="absoluteName" type="xsd:string"/>
    #   <part name="linkedRecordName" type="xsd:string"/>
    #   <part name="ttl" type="xsd:long"/>
    #   <part name="properties" type="xsd:string"/>
    # </message>
    def add_alias_record(cname, linked, ttl = -1, properties = '')
      response = @client.call(:add_alias_record) do |ctx|
        ctx.cookies @cookies
        ctx.message viewId: @view_id, absoluteName: cname,
                    linkedRecordName: linked, ttl: ttl, properties: properties
      end
      @logger.debug("add_alias_record: #{response.body.inspect}")
      response.body
    end

    # add external host record
    # <message name="ProteusAPI_addExternalHostRecord">
    #   <part name="viewId" type="xsd:long"/>
    #   <part name="name" type="xsd:string"/>
    #   <part name="properties" type="xsd:string"/>
    # </message>
    def add_external_host_record(name, properties = '')
      response = @client.call(:add_external_host_record) do |ctx|
        ctx.cookies @cookies
        ctx.message viewId: @view_id, name: name, properties: properties
      end
      @logger.debug("add_external_host_record: #{response.body.inspect}")
      response.body
    end

    # get entity by name
    # <message name="ProteusAPI_getEntityByName">
    #   <part name="parentId" type="xsd:long"/>
    #   <part name="name" type="xsd:string"/>
    #   <part name="type" type="xsd:string"/>
    # </message>
    def get_entity_by_name(name, type)
      response = @client.call(:get_entity_by_name) do |ctx|
        ctx.cookies @cookies
        ctx.message parent_id: @view_id, name: name, type: type
      end
      @logger.debug("get_entity_by_name: #{response.body.inspect}")
      response.body
    end

    # gets some system information
    # <message name="ProteusAPI_getSystemInfoResponse">
    #   <part name="return" type="xsd:string"/>
    # </message>
    def system_info
      @client.call(:get_system_info) { |ctx| ctx.cookies @cookies }.body
    end
  end
end

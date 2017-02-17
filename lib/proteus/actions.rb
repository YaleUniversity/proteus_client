module Proteus
  # Actions is the top level module for API actions
  module Actions
    require 'proteus/actions/entity'
    require 'proteus/actions/host'
    require 'proteus/actions/ipv4'
    require 'proteus/actions/zone'

    # Only allow deletes for certain record types for now
    ALLOWDELETE = [ Proteus::Types::HOSTRECORD,
                    Proteus::Types::EXTERNALHOST,
                    Proteus::Types::CNAMERECORD ]

    include Proteus::Helpers
    include Proteus::Actions::Entity
    include Proteus::Actions::Host
    include Proteus::Actions::Ipv4
    include Proteus::Actions::Zone

    # make a call to the api
    def call(action, message = nil)
      @logger.info "call_action: #{action}, message: #{message.inspect}"
      api_response_obj = (action.to_s + '_response').to_sym
      response = @client.call(action) do |ctx|
        ctx.cookies @cookies
        ctx.message message unless message.nil?
      end.body[api_response_obj][:return]
      @logger.debug("call_action: response_object #{api_response_obj}: #{response.inspect}")
      response
    end

    # gets some system information
    # <message name="ProteusAPI_getSystemInfoResponse">
    #   <part name="return" type="xsd:string"/>
    # </message>
    def system_info
      Proteus::SystemInfo.new call(:get_system_info)
    end
  end
end

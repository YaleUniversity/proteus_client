module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing IPv4 network through the proteus API.
    module Network
      require 'netaddr'

      ##
      # Lists all IPs and properties in a network
      def list_ip4_addresses_by_cidr(cidr)
        list = ::NetAddr::CIDR.create(cidr).enumerate
        list.collect! { |ip| ip_details(ip) }.compact!
        list
      end

      def ip_details(ip)
        {
          address: ip,
          assigned: true,
        }.merge(ip4_address(ip).to_h)
      rescue Proteus::ApiEntityError::EntityNotFound
        { address: ip, assigned: false }
      end

      ##
      # Gets a list of IPv4 networks by a hint
      #   <message name="ProteusAPI_getIP4NetworksByHint">
      #     <part name="containerId" type="xsd:long"/>
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #     <part name="options" type="xsd:string"/>
      #   </message>
      def get_ip4_networks_by_hint(container_id = 0, start = 0, count = 10, options = '')
        response = call(:get_ip4_networks_by_hint, containerId: container_id, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end
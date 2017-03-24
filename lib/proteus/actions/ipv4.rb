module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing IPv4 entities through the proteus API.
    module Ipv4
      ##
      # Assigns the next available IP in a network
      #   <message name="ProteusAPI_assignNextAvailableIP4Address">
      #     <part name="configurationId" type="xsd:long"/>
      #     <part name="parentId" type="xsd:long"/>
      #     <part name="macAddress" type="xsd:string"/>
      #     <part name="hostInfo" type="xsd:string"/>
      #     <part name="action" type="xsd:string"/>
      #     <part name="properties" type="xsd:string"/>
      #   </message>
      def assign_next_available_ip4_address(config_id, parent_id, mac, host_info, action, properties)
        call(:assign_next_available_ip4_address, configurationId: config_id, parentId: parent_id,
             macAddress: mac, hostInfo: host_info, action: action, properties: properties)
      end

      ##
      # Delete a ip address assignment
      def delete_ip4_address(ip, config_id = get_entities.first.id)
        delete(get_ip4_address(config_id, ip).id)
      end

      ##
      # Get an address object by IP with default config id
      def ip4_address(ip)
        get_ip4_address(get_entities.first.id, ip)
      end

      ##
      # Gets an IPv4 address by configuration id and ip
      #   <message name="ProteusAPI_getIP4Address">
      #     <part name="containerId" type="xsd:long"/>
      #     <part name="address" type="xsd:string"/>
      #   </message>
      def get_ip4_address(config_id, address)
        Proteus::ApiEntity.new call(:get_ip4_address, containerId: config_id, address: address)
      end

      ##
      # Gets the next available IPv4 address, but doesn't assign it
      #   <message name="ProteusAPI_getNextIP4Address">
      #     <part name="parentId" type="xsd:long"/>
      #     <part name="properties" type="xsd:string"/>
      #   </message>
      def get_next_ip4_address(parent_id, properties = '')
        call(:get_next_ip4_address, parentId: parent_id, properties: properties)
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

      ##
      # Assign the next ipv4 address by a CIDR
      #
      # This process uses a canary IP in from the cidr provided to get the
      # network_id which is in turn used as the parent to assign the next available IP.
      def assign_next_ip4_address_by_cidr(cidr, hostname, proplist)
        parent = get_parent(canary(cidr).id)
        config = get_entities.first

        # Make assumptions about properties to pass to IP assignment
        # hostname, viewId, reverseFlag, sameAsZoneFlag
        hostinfo = "#{hostname},#{@view_id},true,false"
        properties = "name=#{hostname}"
        properties += "|#{proplist}" unless proplist.nil?
        assign_next_available_ip4_address(config.id, parent.id, '', hostinfo, 'MAKE_STATIC', properties)
      end

      ##
      # Get the next ipv4 address by a CIDR
      #
      # This process uses a canary IP in from the cidr provided to get the
      # network_id which is in turn used as the parent to get the next available IP.
      def get_next_ip4_address_by_cidr(cidr)
        parent = get_parent(canary(cidr).id)
        get_next_ip4_address(parent.id)
      end

      ##
      # Get a canary IP address from a CIDR
      def canary(cidr)
        config_id = get_entities.first.id
        get_ip4_address(config_id, NetAddr::CIDR.create(cidr).nth(1))
      end
    end
  end
end

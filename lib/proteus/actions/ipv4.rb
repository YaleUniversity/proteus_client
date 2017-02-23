module Proteus
  module Actions
    module Ipv4
      # assigns the next available IP in a network
      # <message name="ProteusAPI_assignNextAvailableIP4Address">
      #   <part name="configurationId" type="xsd:long"/>
      #   <part name="parentId" type="xsd:long"/>
      #   <part name="macAddress" type="xsd:string"/>
      #   <part name="hostInfo" type="xsd:string"/>
      #   <part name="action" type="xsd:string"/>
      #   <part name="properties" type="xsd:string"/>
      # </message>
      def assign_next_available_ip4_address(config_id, parent_id, mac, host_info, action, properties)
        call(:assign_next_available_ip4_address, configurationId: config_id, parentId: parent_id,
             macAddress: mac, hostInfo: host_info, action: action, properties: properties)
      end

      # get an IPv4 address by configuration id and ip
      # <message name="ProteusAPI_getIP4Address">
      #   <part name="containerId" type="xsd:long"/>
      #   <part name="address" type="xsd:string"/>
      # </message>
      def get_ip4_address(config_id, address)
        Proteus::ApiEntity.new call(:get_ip4_address, containerId: config_id, address: address)
      end

      # get the next IPv4 address
      # <message name="ProteusAPI_getNextIP4Address">
      #   <part name="parentId" type="xsd:long"/>
      #   <part name="properties" type="xsd:string"/>
      # </message>
      def get_next_ip4_address(parent_id, properties = '')
        call(:get_next_ip4_address, parentId: parent_id, properties: properties)
      end

      # get IPv4 networks by a hint
      # <message name="ProteusAPI_getIP4NetworksByHint">
      #   <part name="containerId" type="xsd:long"/>
      #   <part name="start" type="xsd:int"/>
      #   <part name="count" type="xsd:int"/>
      #   <part name="options" type="xsd:string"/>
      # </message>
      def get_ip4_networks_by_hint(container_id = 0, start = 0, count = 10, options = '')
        response = call(:get_ip4_networks_by_hint, containerId: container_id, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end

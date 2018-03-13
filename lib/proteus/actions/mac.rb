module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing MAC Address records
    module Mac
      ##
      # Get mac address record
      #   <message name="ProteusAPI_getMACAddress">
      #     <part name="configurationId" type="xsd:long"/>
      #     <part name="macAddress" type="xsd:string"/>
      #   </message>
      def get_mac_address(macAddress)
        Proteus::ApiEntity.new call(:get_mac_address, configurationId: @view_id, macAddress: macAddress)
      end
    end
  end
end

module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing zone entities through the proteus API.
    module Zone
      ##
      # Gets a list of zones from a hint
      #   <message name="ProteusAPI_getZonesByHint">
      #     <part name="containerId" type="xsd:long"/>
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #     <part name="options" type="xsd:string"/>
      #   </message>
      def get_zones_by_hint(container_id = 0, start = 0, count = 10, options = '')
        response = call(:get_zones_by_hint, containerId: container_id, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end

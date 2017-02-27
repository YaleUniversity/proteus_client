module Proteus
  module Actions
    module Zone
      # get a list of zones by a hint
      # <message name="ProteusAPI_getZonesByHint">
      #   <part name="containerId" type="xsd:long"/>
      #   <part name="start" type="xsd:int"/>
      #   <part name="count" type="xsd:int"/>
      #   <part name="options" type="xsd:string"/>
      # </message>
      def get_zones_by_hint(container_id = 0, start = 0, count = 10, options = '')
        response = call(:get_zones_by_hint, containerId: container_id, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end

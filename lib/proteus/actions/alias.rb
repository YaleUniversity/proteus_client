module Proteus
  module Actions
    module Alias
      # get a list of alias records by a hint
      # <message name="ProteusAPI_getAliasesByHint">
      #   <part name="start" type="xsd:int"/>
      #   <part name="count" type="xsd:int"/>
      #   <part name="options" type="xsd:string"/>
      # </message>
      def get_aliases_by_hint(start = 0, count = 10, options = '')
        response = call(:get_aliases_by_hint, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end

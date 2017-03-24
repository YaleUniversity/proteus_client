module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing Alias records
    module Alias
      ##
      # Get a list of alias records by a hint
      #   <message name="ProteusAPI_getAliasesByHint">
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #     <part name="options" type="xsd:string"/>
      #   </message>
      def get_aliases_by_hint(start = 0, count = 10, options = '')
        response = call(:get_aliases_by_hint, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      ##
      # Add an alias record
      #   <message name="ProteusAPI_addAliasRecord">
      #     <part name="viewId" type="xsd:long"/>
      #     <part name="absoluteName" type="xsd:string"/>
      #     <part name="linkedRecordName" type="xsd:string"/>
      #     <part name="ttl" type="xsd:long"/>
      #     <part name="properties" type="xsd:string"/>
      #   </message>
      def add_alias_record(cname, linked, ttl = -1, properties = '')
        call(:add_alias_record, viewId: @view_id, absoluteName: cname,
             linkedRecordName: linked, ttl: ttl, properties: properties)
      end

      ##
      # Gets an individual alias record by FQDN
      def get_alias_record(fqdn)
        records = get_aliases_by_hint(0, 2, 'hint=^' + fqdn + '$')
        @logger.debug("Got records: #{records.inspect}")
        msg = 'Received too many records from search!'
        raise Proteus::ApiError::NonDeterministicResponse, msg if records.size > 1
        raise Proteus::ApiEntityError::EntityNotFound, fqdn + ' not found!' if records.size == 0
        records.first
      end

      ##
      # Delete an alias record
      def delete_alias_record(fqdn)
        delete(get_alias_record(fqdn).id)
      end
    end
  end
end

module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing Host records through the proteus API.
    module Host
      ##
      # Adds a host record
      #   <message name="ProteusAPI_addHostRecord">
      #     <part name="viewId" type="xsd:long"/>
      #     <part name="absoluteName" type="xsd:string"/>
      #     <part name="addresses" type="xsd:string"/>
      #     <part name="ttl" type="xsd:long"/>
      #     <part name="properties" type="xsd:string"/>
      #   </message>
      def add_host_record(fqdn, ip, ttl = -1, properties = '')
        call(:add_host_record, viewId: @view_id, absoluteName: fqdn,
             addresses: ip, ttl: ttl, properties: properties)
      end

      ##
      # Adds an external host record
      #   <message name="ProteusAPI_addExternalHostRecord">
      #     <part name="viewId" type="xsd:long"/>
      #     <part name="name" type="xsd:string"/>
      #     <part name="properties" type="xsd:string"/>
      #   </message>
      def add_external_host_record(name, properties = '')
        call(:add_external_host_record, viewId: @view_id, name: name, properties: properties )
      end

      ##
      # Gets a list of host records by a hint
      #   <message name="ProteusAPI_getHostRecordsByHint">
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #     <part name="options" type="xsd:string"/>
      #   </message>
      def get_host_records_by_hint(start = 0, count = 10, options = '')
        response = call(:get_host_records_by_hint, start: start, count: count, options: options)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      ##
      # Gets an individual host record by FQDN
      def get_host_record(fqdn)
        records = get_host_records_by_hint(0, 2, 'hint=^' + fqdn + '$')
        @logger.debug("Got records: #{records.inspect}")
        msg = 'Received too many records from search!'
        raise Proteus::ApiError::NonDeterministicResponse, msg if records.size > 1
        raise Proteus::ApiEntityError::EntityNotFound, fqdn + ' not found!' if records.size == 0
        records.first
      end

      ##
      # Delete a host record by name
      def delete_host_record(fqdn)
        delete(get_host_record(fqdn).id)
      end

      ##
      # Delete an external record by name
      def delete_external_record(name)
        delete(get_entity_by_name(@view_id, name, Proteus::Types::EXTERNALHOST).id)
      end
    end
  end
end

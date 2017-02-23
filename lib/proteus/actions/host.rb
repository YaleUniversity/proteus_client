module Proteus
  module Actions
    module Host
      # add host record
      # <message name="ProteusAPI_addHostRecord">
      #   <part name="viewId" type="xsd:long"/>
      #   <part name="absoluteName" type="xsd:string"/>
      #   <part name="addresses" type="xsd:string"/>
      #   <part name="ttl" type="xsd:long"/>
      #   <part name="properties" type="xsd:string"/>
      # </message>
      def add_host_record(fqdn, ip, ttl = -1, properties = '')
        call(:add_host_record, viewId: @view_id, absoluteName: fqdn,
             addresses: ip, ttl: ttl, properties: properties)
      end

      # add alias record
      # <message name="ProteusAPI_addAliasRecord">
      #   <part name="viewId" type="xsd:long"/>
      #   <part name="absoluteName" type="xsd:string"/>
      #   <part name="linkedRecordName" type="xsd:string"/>
      #   <part name="ttl" type="xsd:long"/>
      #   <part name="properties" type="xsd:string"/>
      # </message>
      def add_alias_record(cname, linked, ttl = -1, properties = '')
        call(:add_alias_record, viewId: @view_id, absoluteName: cname,
             linkedRecordName: linked, ttl: ttl, properties: properties)
      end

      # add external host record
      # <message name="ProteusAPI_addExternalHostRecord">
      #   <part name="viewId" type="xsd:long"/>
      #   <part name="name" type="xsd:string"/>
      #   <part name="properties" type="xsd:string"/>
      # </message>
      def add_external_host_record(name, properties = '')
        call(:add_external_host_record, viewId: @view_id, name: name, properties: properties )
      end
    end
  end
end

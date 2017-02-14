module Proteus
  # Actions is a collection of API actions
  module Actions

    # Only allow deletes for certain record types for now
    ALLOWDELETE = [Proteus::Types::HOSTRECORD, Proteus::Types::EXTERNALHOST, Proteus::Types::CNAMERECORD]

    include Proteus::Helpers

    # make a call to the api
    def call(action, message = nil)
      @logger.info "call_action: #{action}, message: #{message.inspect}"
      api_response_obj = (action.to_s + '_response').to_sym
      response = @client.call(action) do |ctx|
        ctx.cookies @cookies
        ctx.message message unless message.nil?
      end.body[api_response_obj][:return]
      @logger.debug("call_action: response_object #{api_response_obj}: #{response.inspect}")
      response
    end

    # gets some system information
    # <message name="ProteusAPI_getSystemInfoResponse">
    #   <part name="return" type="xsd:string"/>
    # </message>
    def system_info
      Proteus::SystemInfo.new call(:get_system_info)
    end

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

    # deletes an object by id
    # <message name="ProteusAPI_delete">
    #   <part name="objectId" type="xsd:long"/>
    # </message>
    def delete(id)
      entity = get_entity_by_id(id)
      if ALLOWDELETE.include?(entity.type)
        call(:delete, object_id: id)
      else
        raise 'Not allowed to delete entity with type: ' + entity.type
      end
    end

    # get entity by id
    # <message name="ProteusAPI_getEntityById">
    #   <part name="id" type="xsd:long"/>
    # </message>
    def get_entity_by_id(id = nil)
      Proteus::ApiEntity.new call(:get_entity_by_id, id: id || @view_id)
    end

    # get entity by name
    # <message name="ProteusAPI_getEntityById">
    #   <part name="id" type="xsd:long"/>
    # </message>
    def get_entity_by_name(parent_id = 0, name, type)
      parent_id ||= @view_id
      Proteus::ApiEntity.new call(:get_entity_by_name, parentId: parent_id, name: name, type: type)
    end

    # get top level configurations
    # <message name="ProteusAPI_getEntities">
    #   <part name="parentId" type="xsd:long"/>
    #   <part name="type" type="xsd:string"/>
    #   <part name="start" type="xsd:int"/>
    #   <part name="count" type="xsd:int"/>
    # </message>
    def get_entities(parent_id = 0, type = Proteus::Types::CONFIGURATION, start = 0, count = 10)
      response = Proteus::ApiEntity.new call(:get_entities, parentId: parent_id, type: type,
                                             start: start, count: count)
      normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
    end

    # get parent entity
    # <message name="ProteusAPI_getParent">
    #   <part name="entityId" type="xsd:long"/>
    # </message>
    def get_parent(id = nil)
      Proteus::ApiEntity.new call(:get_parent, entityId: id || @view_id)
    end

    # search by categories
    # <message name="ProteusAPI_searchByCategory">
    #   <part name="keyword" type="xsd:string"/>
    #   <part name="category" type="xsd:string"/>
    #   <part name="start" type="xsd:int"/>
    #   <part name="count" type="xsd:int"/>
    # </message>
    def search_by_category(keyword, category = 'ALL', start = 0, count = 10)
      response = call(:search_by_category, keyword: keyword, category: category, start: start, count: count)
      normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
    end

    # search by object types
    # <message name="ProteusAPI_searchByObjectTypes">
    #   <part name="keyword" type="xsd:string"/>
    #   <part name="types" type="xsd:string"/>
    #   <part name="start" type="xsd:int"/>
    #   <part name="count" type="xsd:int"/>
    # </message>
    def search_by_object_types(keyword, types = Proteus::Types::GENERICRECORD, start = 0, count = 10)
      response = call(:search_by_object_types, keyword: keyword, types: types, start: start, count: count)
      normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
    end
  end
end

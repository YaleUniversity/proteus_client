module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing generic entities
    # through the proteus API.
    module Entity
      ##
      # Search for entities by object types and a keyword
      #   <message name="ProteusAPI_customSearch">
      #     <part name="filters" type="ns6:stringArray"/>
      #     <part name="type" type="xsd:string"/>
      #     <part name="options" type="ns7:stringArray"/>
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #   </message>
      def custom_search(filters, type, options = [], start = 0, count = 100)
        response = call(:custom_search, filters: { item: filters }, type: type, options: { item: options }, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      ##
      # Gets the parent entity from an entityId
      #   <message name="ProteusAPI_getParent">
      #     <part name="entityId" type="xsd:long"/>
      #   </message>
      def get_parent(id = nil)
        Proteus::ApiEntity.new call(:get_parent, entityId: id || @view_id)
      end

      ##
      # Gets a list of entities from a parent entity ID and an entity type.
      # By default it returns the top level configuration
      #   <message name="ProteusAPI_getEntities">
      #     <part name="parentId" type="xsd:long"/>
      #     <part name="type" type="xsd:string"/>
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #   </message>
      def get_entities(parent_id = 0, type = Proteus::Types::CONFIGURATION, start = 0, count = 10)
        response = call(:get_entities, parentId: parent_id, type: type, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      ##
      # Deletes an entity by entityId
      #   <message name="ProteusAPI_delete">
      #     <part name="objectId" type="xsd:long"/>
      #   </message>
      def delete(id)
        entity = get_entity_by_id(id)
        if ALLOWDELETE.include?(entity.type)
          call(:delete, object_id: id)
        else
          msg = 'Not allowed to delete entity with type: ' + entity.type
          raise Proteus::ApiEntityError::ActionNotAllowed, msg
        end
      end

      ##
      # Gets an entity by entityId
      #   <message name="ProteusAPI_getEntityById">
      #     <part name="id" type="xsd:long"/>
      #   </message>
      def get_entity_by_id(id = nil)
        Proteus::ApiEntity.new call(:get_entity_by_id, id: id || @view_id)
      end

      ##
      # Gets an entity by name
      # Finding a specific entity by name requires the parentId and the type of entity
      #   <message name="ProteusAPI_getEntityByName">
      #     <part name="parentId" type="xsd:long"/>
      #     <part name="name" type="xsd:string"/>
      #     <part name="type" type="xsd:string"/>
      #   </message>
      def get_entity_by_name(parent_id = 0, name, type)
        parent_id ||= @view_id
        Proteus::ApiEntity.new call(:get_entity_by_name, parentId: parent_id, name: name, type: type)
      end

      ##
      # Gets an entity by CIDR
      #   <message name="ProteusAPI_getEntityByCIDR">
      #     <part name="parentId" type="xsd:long"/>
      #     <part name="cidr" type="xsd:string"/>
      #     <part name="type" type="xsd:string"/>
      #   </message>
      def get_entity_by_cidr(parent_id = 0, cidr = '0.0.0.0/0', type = Proteus::Types::IP4NETWORK)
        parent_id ||= @view_id
        Proteus::ApiEntity.new call(:get_entity_by_cidr, parentId: parent_id, cidr: cidr, type: type)
      end

      ##
      # Gets an entity by Range
      #   <message name="ProteusAPI_getEntityByCIDR">
      #     <part name="parentId" type="xsd:long"/>
      #     <part name="cidr" type="xsd:string"/>
      #     <part name="type" type="xsd:string"/>
      #   </message>
      def get_entity_by_range(parent_id = 0, addr1 = '0.0.0.0', addr2 = '0.0.0.0', type = Proteus::Types::IP4NETWORK)
        parent_id ||= @view_id
        Proteus::ApiEntity.new call(:get_entity_by_range, parentId: parent_id, address1: addr1, address2: addr2, type: type)
      end

      ##
      # Search for entities by category and a keyword
      #    <message name="ProteusAPI_searchByCategory">
      #     <part name="keyword" type="xsd:string"/>
      #     <part name="category" type="xsd:string"/>
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #   </message>
      def search_by_category(keyword, category = 'ALL', start = 0, count = 10)
        response = call(:search_by_category, keyword: keyword, category: category, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      ##
      # Search for entities by object types and a keyword
      #   <message name="ProteusAPI_searchByObjectTypes">
      #     <part name="keyword" type="xsd:string"/>
      #     <part name="types" type="xsd:string"/>
      #     <part name="start" type="xsd:int"/>
      #     <part name="count" type="xsd:int"/>
      #   </message>
      def search_by_object_types(keyword, types = Proteus::Types::GENERICRECORD, start = 0, count = 10)
        response = call(:search_by_object_types, keyword: keyword, types: types, start: start, count: count)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end

      ##
      # Update an entity
      #   <message name="ProteusAPI_update">
      #     <part name="entity" type="tns:APIEntity"/>
      #   </message>
      def update(entity)
        call(:update, entity: { id: entity.id, name: entity.name, type: entity.type, properties: entity.properties.to_s })
      end

      ##
      # Update the properties for a given entity
      def update_properties(id, properties)
        entity = get_entity_by_id(id)
        current_properties = entity.to_h[:properties]
        new_properties = decompose(properties)
        entity.properties = Proteus::EntityProperties.new(compose(current_properties.merge(new_properties)))
        update(entity)
        entity
      end
    end
  end
end

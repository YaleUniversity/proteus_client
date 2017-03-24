module Proteus
  module Actions
    ##
    # This module encapsulates the actions related to managing user defined fields through the proteus API.
    module Udf
      ##
      # Get user defined fields
      #   <message name="ProteusAPI_getUserDefinedFields">
      #     <part name="type" type="xsd:string"/>
      #     <part name="requiredFieldsOnly" type="xsd:boolean"/>
      #   </message>
      def get_user_defined_fields(type = Proteus::Types::ENTITY, required = false)
        response = call(:get_user_defined_fields, type: type, required_fields_only: required)
        normalize(response).collect { |i| Proteus::ApiEntity.new(i) }
      end
    end
  end
end

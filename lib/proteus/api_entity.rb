module Proteus
  # ApiEntity describes an API service Entity object
  #   @id: The database ID of the object in Address Manager.
  #   @name: The field name, which might be null.
  #   @type: The class name of the object.  This field cannot be null.
  #   @properties: A hash that contains properties for the object (decomposed)
  class ApiEntity

    include Proteus::Helpers

    attr_accessor :id, :name, :type

    def initialize(attributes = {})
      raise 'Cannot initialize empty API entity' if attributes.nil?
      @id = attributes[:id]
      @name = attributes[:name]
      @type = attributes[:type]
      @properties = decompose(attributes[:properties])
    end

    def properties
      return '' if @properties.nil?
      compose(@properties)
    end

    def properties=(prop_string)
      @properties = decompose(prop_string)
    end

    def inspect
      instance_variables.collect do |v|
        "#{v.to_s.gsub('@','')}: #{instance_variable_get(v)}"
      end.join("\n")
    end
  end
end
module Proteus
  ##
  # ApiEntity describes an API service Entity object
  #   @id: The database ID of the object in Address Manager.
  #   @name: The field name, which might be null.
  #   @type: The class name of the object.  This field cannot be null.
  #   @properties: A hash that contains properties for the object (decomposed)
  class ApiEntity
    require 'awesome_print'

    include Proteus::Helpers
    include Proteus::ApiEntityError

    attr_accessor :id, :name, :type, :properties

    def initialize(attributes = {})
      raise Proteus::ApiEntityError::EntityNotFound, 'Cannot initialize empty API entity' if attributes.nil?
      @id = attributes[:id]
      @name = attributes[:name]
      @type = attributes[:type]
      @properties = Proteus::EntityProperties.new(attributes[:properties])
    end

    def inspect
      to_h.awesome_inspect
    end

    def to_h
      {
        id: @id,
        name: @name,
        type: @type,
        properties: @properties.to_h
      }
    end

    def to_s
      instance_variables.collect do |v|
        "#{v.to_s.gsub('@','')}: #{instance_variable_get(v)}"
      end.join(' | ')
    end
  end

  class EntityProperties
    require 'ostruct'

    include Proteus::Helpers

    def initialize(properties = '')
      @properties = OpenStruct.new(decompose(properties))
    end

    def to_h
      @properties.to_h
    end

    def to_s
      compose(@properties.to_h)
    end

    def method_missing(method_sym, *arguments, &block)
      puts "calling method missing with #{method_sym} : #{arguments.first}"
      if @properties.respond_to?(method_sym)
        @properties.send(method_sym, arguments.first)
      else
        super
      end
    end
  end
end

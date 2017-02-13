module Proteus
  # SystemInfo describes a proteus system information object
  #   @hostname: The host name of the Address Manager server.
  #   @version: The version of the Address Manager software
  #   @address: The IP address of the Address Manager server.
  #   @cluster_role: The role of the server in an XHA pair, either primary or secondary.
  #   @replication_role: The role of the server in database replication, either primary or secondary.
  #   @replication_status: The status of the replication service on the Address Manager server.
  #   @entity_count: The number of entities within the Address Manager database.
  #   @database_size: The size, in megabytes, of the Address Manager database.
  #   @logged_in_users: The number of users presently logged in to Address Manager
  class SystemInfo
    include Proteus::Helpers

    attr_reader :hostname, :version, :address, :cluster_role, :replication_role, :replication_status,
                :entity_count, :database_size, :logged_in_users

    def initialize(properties)
      attributes = decompose(properties)
      @hostname = attributes[:hostName]
      @version = attributes[:version]
      @address = attributes[:address]
      @cluster_role = attributes[:clusterRole]
      @replication_role = attributes[:replicationRole]
      @replication_status = attributes[:replicationStatus]
      @entity_count = attributes[:entityCount]
      @database_size = attributes[:databaseSize]
      @logged_in_users = attributes[:loggedInUsers]
    end

    def inspect
      instance_variables.collect do |v|
        "#{v.to_s.gsub('@','')}: #{instance_variable_get(v)}"
      end.join("\n")
    end
  end
end

# Library for various Proteus DNS API calls
#
require 'savon'
require 'yaml'

CONFIG = YAML::load_file('config/config.yml')
@debug = CONFIG['logging']['debug'] || false


# Log into Proteus
def login!
  begin
    response = @client.call(:login, message: { 
      username: CONFIG['bluecat']['user'], 
      password: CONFIG['bluecat']['password'] })
    puts "Proteus login: #{response.body}" if @debug
  end

  # Set the HTTP Cookie in the headers for all future calls
  @auth_cookies = response.http.cookies
end

# add host record
def add_host_record(host_fqdn, host_ip, view_id=CONFIG['bluecat']['default_viewid'], ttl=-1, properties='')
  response = @client.call(:add_host_record) do |ctx|
    ctx.cookies @auth_cookies
    ctx.message viewId: view_id, absoluteName: host_fqdn, addresses: host_ip, ttl: ttl, properties: properties 
  end
  puts "add_host_record: #{response.body.inspect}" if @debug
  response.body
end

# add alias record
def add_alias_record(host_alias, host_linked, view_id=CONFIG['bluecat']['default_viewid'], ttl=-1, properties='')
  response = @client.call(:add_alias_record) do |ctx|
    ctx.cookies @auth_cookies
    ctx.message viewId: view_id, absoluteName: host_alias, linkedRecordName: host_linked, ttl: ttl, properties: properties 
  end
  puts "add_alias_record: #{response.body.inspect}" if @debug
  response.body
end

def get_system_info
  @client.call(:get_system_info) { |ctx| ctx.cookies @auth_cookies }.body
end

# get configuration
#config_name = 'Yale Network'
#response = client.call(:search_by_object_types) do |ctx|
#  ctx.cookies auth_cookies
#  ctx.message keyword: config_name, types: 'Configuration', start: 0, count: 1
#end
#puts "Configuration Search result: #{response.body.inspect}" if @debug
#config_id = response.body[:search_by_object_types_response][:return][:item][:id]
#items = canonical_items(response.body[:get_entities_response])

#response = client.call(:get_entities) do |ctx|
#  ctx.cookies auth_cookies
#  ctx.message parentId: config_id, type: 'IP4Block', start: 0, count: 10
#end
# puts "Search result: #{response.body.inspect}" if @debug
#items = canonical_items(response.body[:get_entities_response])
#puts items

#network_name = 'private networks 172.16/12'
#response = client.call(:get_entity_by_name) do |ctx|
#  ctx.cookies auth_cookies
#  ctx.message parentId: config_id, name: network_name, type: 'IP4Block'
#end
#puts "Search result: #{response.body.inspect}" if @debug
#network_id = response.body[:get_entity_by_name_response][:return][:id]


# initialize API client
@client = Savon.client do
  wsdl "#{CONFIG['bluecat']['url']}/Services/API?wsdl"
  ssl_verify_mode :none
  log @debug
end

unless @client.nil?
  # puts client.operations if @debug
  login!
else
  abort "Error initializing API client!"
end

puts "Proteus System Info: #{get_system_info}" if @debug

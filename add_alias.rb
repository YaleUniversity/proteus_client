# Add an alias (CNAME) to an existing host record
# Usage:
#   ruby add_alias.rb myalias.its.yale.internal myhost.its.yale.internal
#

unless ARGV.length >= 2
  puts 'Error: add_host needs 2 arguments!'
  puts 'Usage:'
  puts '  ruby add_alias.rb myalias.its.yale.internal myhost.its.yale.internal'
  exit 1
end

require_relative 'dns'

alias = ARGV[0]
host_fqdn = ARGV[1]

add_alias_record(alias, host_fqdn)

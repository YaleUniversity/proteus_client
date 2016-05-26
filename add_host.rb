# Add a host (A) record
# Usage:
#   ruby add_host.rb myhost.its.yale.internal 172.16.1.99
#

unless ARGV.length >= 2
  puts 'Error: add_host needs 2 arguments!'
  puts 'For example:'
  puts '  ruby add_host.rb myhost.its.yale.internal 172.16.1.99'
  exit 1
end

require_relative 'dns'

host_fqdn = ARGV[0]
host_ip = ARGV[1]

puts "Adding host record #{host_fqdn} for #{host_ip} ... "

add_host_record(host_fqdn, host_ip)

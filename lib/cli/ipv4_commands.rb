module ProteusCli
  module Ipv4Commands
    def define_root(cmd)
      cmd.define_command do
        name        'ip'
        usage       'ip [options]'
        summary     'manage ip address records'
        option :c, :configid, 'Override config id, default gets the first entity in the view', argument: :required
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'assign'
        usage   'assign [options] cidr fqdn [properties]'
        summary 'assign the next available ip by cidr'
        desc = 'Assigns the next available IP address by CIDR.  Behind the scenes, this is generating '
        desc += 'a "canary" ip address which is used to get the network ID which is used as the parent '
        desc += 'for assignment. Properties are currently passed as a string of key=value pairs separated '
        desc += 'by "|".  ie. "foo=bar|baz=buz|boz=biz"'
        description desc

        run do |opts, args|
          exit_2 'IP assign requires at least 2 args' unless args.size >= 2
          configure(opts)
          ap proteus { |c| c.assign_next_ip4_address_by_cidr(args[0], args[1], args[2]) }
        end
      end

      cmd.define_command do
        name    'delete'
        usage   'delete [options] ip'
        summary 'delete an ip assignment'

        run do |opts, args|
          exit_2 'IP delete requires 1 args' unless args.size == 1
          configure(opts)
          $stdout.puts 'success' if proteus { |c| c.delete_ip4_address(args[0]) }.nil?
        end
      end

      cmd.define_command do
        name    'next'
        usage   'next [options] cidr'
        summary 'show the next available ip by cidr'
        desc = 'Shows the next available IP address by CIDR.  Behind the scenes, this is generating '
        desc += 'a "canary" ip address which is used to get the network ID which is used as the parent '
        desc += 'for finding the next IP.'
        description desc

        run do |opts, args|
          exit_2 'IP next requires 1 args' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_next_ip4_address_by_cidr(args[0]) }
        end
      end

      cmd.define_command do
        name    'show'
        usage   'show [options] ip'
        summary 'show an ip assignment'

        run do |opts, args|
          exit_2 'IP show requires 1 args' unless args.size == 1
          configure(opts)
          proteus do |c|
            if opts[:config_id]
              ap c.get_ip4_address(opts[:config_id], args[0])
            else
              ap c.ip4_address(args[0])
            end
          end
        end
      end

      cmd.define_command do
        name    'udf'
        usage   'udf'
        summary 'list user defined fields for ip addresses'
        flag :r, :required, 'Only return required user defined fields'

        run do |opts, _|
          configure(opts)
          opts[:required] ||= false
          proteus do |c|
            type = Proteus::Types::IP4ADDRESS
            ap Hash[c.get_user_defined_fields(type, opts[:required]).collect { |u| [u.name, u.type] }]
          end
        end
      end
    end
  end
end

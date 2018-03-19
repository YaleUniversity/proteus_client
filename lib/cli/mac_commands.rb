module ProteusCli
  module MacCommands
    def define_root(cmd)
      cmd.define_command do
        name        'mac'
        usage       'mac [options]'
        summary     'Manage MAC address records'
        description 'Create/find/delete a MAC address in Proteus'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'add'
        usage   'add [options] macAddress [properties]'
        summary 'Adds a MAC address'
        desc = 'Adds a MAC address to the Proteus database.'
        desc += 'Properties is a string of key value pairs. ie: "foo=bar|baz=biz|buz=boz'
        description desc

        option :r, :properties, 'Properties to send to Proteus on creation', argument: :required

        run do |opts, args|
            exit_2 'mac add requires 1 or more args' unless args.size >= 1
            configure(opts)
            ap proteus { |c| c.add_mac_address(args[0], opts[:properties] || '') }
        end
      end

      cmd.define_command do
        name    'show'
        usage   'show [options] macAddress'
        summary 'Shows a MAC address record'

        run do |opts, args|
          exit_2 'mac show requires 1 arg' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_mac_address(args[0]) }
        end
      end

      cmd.define_command do
        name    'search'
        usage   'search [options] term'
        summary 'Searches for MAC address records'
        desc = 'Searches for MAC address records'
        description desc

        option :l, :limit, 'How many records to return (max: 10, default: 10)', argument: :required
        option :s, :start, 'Which record to start with, ie. offset (default: 0)', argument: :required

        run do |opts, args|
          exit_2 'mac search requires 1 arg' unless args.size == 1
          configure(opts)
          opts[:start] ||= 0
          opts[:limit] ||= 10
          type = Proteus::Types::MACADDRESS
          ap proteus { |c| c.search_by_object_types(args[0], type, opts[:start], opts[:limit]) }
        end
      end

      cmd.define_command do
        name    'associate'
        usage   'associate [options] macAddress macPool'
        summary 'Associate a mac address record with a mac pool record'

        run do |opts, args|
          exit_2 'mac associate requires 2 args: "MAC address" & "MAC pool ID"' unless args.size == 2
          configure(opts)
          ap proteus { |c| c.associate_mac_address_with_pool(args[0], args[1]) }
        end
      end
    end
  end
end

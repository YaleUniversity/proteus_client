module ProteusCli
  module MacCommands
    def define_root(cmd)
      cmd.define_command do
        name        'mac'
        usage       'mac [options]'
        summary     'manage mac address records'
        description 'Create/find/delete mac address in proteus'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'show'
        usage   'show [options] configurationId macAddress'
        summary 'show mac address record'

        run do |opts, args|
          exit_2 'Mac show requires 2 args' unless args.size >= 2
          configure(opts)
          ap proteus { |c| c.get_mac_address(args[0], args[1]) }
        end
      end

      cmd.define_command do
        name    'search'
        usage   'search [options] term'
        summary 'searches for mac address records'
        desc = 'Searches for mac address records'
        description desc

        option :l, :limit, 'How many records to return (max: 10, default: 10)', argument: :required
        option :s, :start, 'Which record to start with, ie. offset (default: 0)', argument: :required

        run do |opts, args|
          exit_2 'Mac search requires 1 args' unless args.size == 1
          configure(opts)
          opts[:start] ||= 0
          opts[:limit] ||= 10
          type = Proteus::Types::MACADDRESS
          ap proteus { |c| c.search_by_object_types(args[0], type, opts[:start], opts[:limit]) }
        end
      end
    end
  end
end
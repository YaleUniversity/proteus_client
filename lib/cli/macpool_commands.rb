module ProteusCli
  module MacPoolCommands
    def define_root(cmd)
      cmd.define_command do
        name        'macpool'
        usage       'macpool [options]'
        summary     'manage macpools'
        description 'Find MAC Pools in Proteus'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'search'
        usage   'search [options] term'
        summary 'Searches for MAC Pools'
        desc = 'Searches for MAC Pools'
        description desc

        option :l, :limit, 'How many records to return (max: 10, default: 10)', argument: :required
        option :s, :start, 'Which record to start with, ie. offset (default: 0)', argument: :required

        run do |opts, args|
          exit_2 'macpool search requires 1 arg' unless args.size == 1
          configure(opts)
          opts[:start] ||= 0
          opts[:limit] ||= 10
          type = Proteus::Types::MACPOOL
          ap proteus { |c| c.search_by_object_types(args[0], type, opts[:start], opts[:limit]) }
        end
      end
    end
  end
end

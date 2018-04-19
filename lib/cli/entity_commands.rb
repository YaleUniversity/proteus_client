module ProteusCli
  module EntityCommands
    def define_root(cmd)
      cmd.define_command do
        name        'id'
        usage       'id [options]'
        summary     'manage proteus entities by id'
        description 'All proteus entities have an internal id.  This allows management by that id.'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'delete'
        usage   'id [options] id'
        summary 'delete an entity by id'

        run do |opts, args|
          exit_2 'ID delete requires 1 args' unless args.size == 1
          configure(opts)
          $stdout.puts 'success' if proteus { |c| c.delete(args[0]) }.nil?
        end
      end

      cmd.define_command do
        name    'search'
        usage   'search [options] type filters'
        summary 'custom search based on type and filters'
        desc = 'Performs a custom search based on object type and filters. '
        desc += 'The type is one of the standard Proteus types, e.g. HostRecord, or MACAddress. '
        desc += 'Filters is a list of properties on which the search will be based, i.e. "reg_by=me&description=Device"'
        description desc

        run do |opts, args|
          exit_2 'search requires 2 args' unless args.size == 2
          configure(opts)
          supported_types = Proteus::Types.constants(false).map(&Proteus::Types.method(:const_get))
          exit_2 "Unknown type #{args[0]}\nSupported types are: #{supported_types.inspect}" unless supported_types.include? args[0]
          ap proteus { |c| c.custom_search(args[1].split('&'), args[0]) }
        end
      end

      cmd.define_command do
        name    'show'
        usage   'show [options] id'
        summary 'show an entity by id'

        run do |opts, args|
          exit_2 'ID show requires 1 args' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_entity_by_id(args[0]) }
        end
      end

      cmd.define_command do
        name    'parent'
        usage   'parent [options] id'
        summary 'show the parent of an entity by id'

        run do |opts, args|
          exit_2 'ID parent requires 1 args' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_parent(args[0]) }
        end
      end
    end
  end
end

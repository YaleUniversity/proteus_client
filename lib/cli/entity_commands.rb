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

module ProteusCli
  module AliasCommands
    def define_root(cmd)
      cmd.define_command do
        name        'alias'
        usage       'alias [options]'
        summary     'manage external host dns records'
        description 'Create/find/delete alias records in proteus'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'add'
        usage   'add [options] cname linked [ttl] [properties]'
        summary 'add an alias dns record'
        desc = 'Adds an alias record.  Required arguments are fully-qualified cname and the linked '
        desc += 'record.  TTL and properties are optional.  TTL is in seconds, properties is a string '
        desc += 'of key value pairs ie. "foo=bar|baz=biz|buz=boz"'
        description desc

        option :t, :ttl, 'TTL for entry in seconds (default: 300)', argument: :required
        option :r, :properties, 'Properties to send to proteus on creation', argument: :required

        run do |opts, args|
          exit_2 'Alias add requires 2 or more args' unless args.size >= 2
          configure(opts)
          ap proteus { |c| c.add_alias_record(args[0], args[1], opts[:ttl] || 300 , opts[:properties] || '') }
        end
      end

      cmd.define_command do
        name 'delete'
        usage   'delete [options] fqdn'
        summary 'delete an alias dns record'

        run do |opts, args|
          exit_2 'Alias add requires 1 args' unless args.size == 1
          configure(opts)
          $stdout.puts 'success' if proteus { |c| c.delete_alias_record(args[0]) }.nil?
        end
      end

      cmd.define_command do
        name    'search'
        usage   'search [options] term'
        summary 'searches for alias dns records'
        desc = 'Searches for alias dns records by hint or keyword.  The default is to search by hint.  Passing '
        desc += '-k/--keyword will change the term to a keyword. The following wildcards are supported in the '
        desc += 'hint option. * ^-matches the beginning of a string. * $-matches the end of a string. '
        desc += '* ?-matches any one character * *-matches one or more characters within a string.'
        description desc

        flag :k, :keyword, 'Given term is a "keyword"'
        option :l, :limit, 'How many records to return (max: 10, default: 10)', argument: :required
        option :s, :start, 'Which record to start with, ie. offset (default: 0)', argument: :required

        run do |opts, args|
          exit_2 'Alias search requires 1 args' unless args.size == 1
          configure(opts)
          opts[:start] ||= 0
          opts[:limit] ||= 10
          if opts[:keyword]
            type = Proteus::Types::CNAMERECORD
            ap proteus { |c| c.search_by_object_types(args[0], type, opts[:start], opts[:limit]) }
          else
            ap proteus { |c| c.get_aliases_by_hint(opts[:start], opts[:limit], 'hint=' + args[0]) }
          end
        end
      end

      cmd.define_command do
        name    'show'
        usage   'show [options] cname'
        summary 'show an alias dns record'

        run do |opts, args|
          exit_2 'Alias show requires 1 args' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_alias_record(args[0]) }
        end
      end

      cmd.define_command do
        name    'udf'
        usage   'udf'
        summary 'list user defined fields for alias records'
        flag :r, :required, 'Only return required user defined fields'

        run do |opts, _|
          configure(opts)
          opts[:required] ||= false
          proteus do |c|
            type = Proteus::Types::CNAMERECORD
            ap Hash[c.get_user_defined_fields(type, opts[:required]).collect { |u| [u.name, u.type] }]
          end
        end
      end
    end
  end
end

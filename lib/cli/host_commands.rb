module ProteusCli
  module HostCommands
    def define_root(cmd)
      cmd.define_command do
        name        'host'
        usage       'host [options]'
        summary     'manage host dns records'
        description 'Create/find/delete host records in proteus'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'add'
        usage   'add [options] fqdn ip [ttl] [properties]'
        summary 'add a host dns record'
        desc = 'Adds a host record.  Required arguments are fully-qualified domain name and ip.  TTL and '
        desc += 'properties are optional.  TTL is in seconds, properties is a string of key value pairs '
        desc += 'ie. "foo=bar|baz=biz|buz=boz"'
        description desc

        option :t, :ttl, 'TTL for entry in seconds (default: 300)', argument: :required
        option :r, :properties, 'Properties to send to proteus on creation', argument: :required

        run do |opts, args|
          exit_2 'Host add requires 2 or more args' unless args.size >= 2
          configure(opts)
          proteus do |c|
            i = c.add_host_record(args[0], args[1], opts[:ttl] || 300 , opts[:properties] || '')
            ap c.get_entity_by_id(i)
          end
        end
      end

      cmd.define_command do
        name 'delete'
        usage   'delete [options] fqdn'
        summary 'delete a host dns record'

        run do |opts, args|
          exit_2 'Host add requires 1 args' unless args.size == 1
          configure(opts)
          $stdout.puts 'success' if proteus { |c| c.delete_host_record(args[0]) }.nil?
        end
      end

      cmd.define_command do
        name    'search'
        usage   'search [options] term'
        summary 'searches for host dns records'
        desc = 'Searches for host dns records by hint or keyword.  The default is to search by hint.  Passing '
        desc += '-k/--keyword will change the term to a keyword. The following wildcards are supported in the '
        desc += 'hint option. * ^-matches the beginning of a string. * $-matches the end of a string. '
        desc += '* ?-matches any one character * *-matches one or more characters within a string.'
        description desc

        flag :k, :keyword, 'Given term is a "keyword"'
        option :l, :limit, 'How many records to return (max: 10, default: 10)', argument: :required
        option :s, :start, 'Which record to start with, ie. offset (default: 0)', argument: :required

        run do |opts, args|
          exit_2 'Host search requires 1 args' unless args.size == 1
          configure(opts)
          opts[:start] ||= 0
          opts[:limit] ||= 10
          if opts[:keyword]
            type = Proteus::Types::HOSTRECORD
            ap proteus { |c| c.search_by_object_types(args[0], type, opts[:start], opts[:limit]) }
          else
            ap proteus { |c| c.get_host_records_by_hint(opts[:start], opts[:limit], 'hint=' + args[0]) }
          end
        end
      end

      cmd.define_command do
        name    'show'
        usage   'show [options] fqdn'
        summary 'show a host dns record'

        run do |opts, args|
          exit_2 'Host add requires 1 args' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_host_record(args[0]) }
        end
      end

      cmd.define_command do
        name    'udf'
        usage   'udf'
        summary 'list user defined fields for host records'
        flag :r, :required, 'Only return required user defined fields'

        run do |opts, _|
          configure(opts)
          opts[:required] ||= false
          proteus do |c|
            type = Proteus::Types::HOSTRECORD
            ap Hash[c.get_user_defined_fields(type, opts[:required]).collect { |u| [u.name, u.type] }]
          end
        end
      end
    end
  end
end

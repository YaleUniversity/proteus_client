module ProteusCli
  module ExternalHostCommands
    def define_root(cmd)
      cmd.define_command do
        name        'external'
        usage       'external [options]'
        summary     'manage external host dns records'
        desc = 'Create/find/delete external host records in proteus. External records are '
        desc += 'just internal proteus representations of someone else\'s dns record.  They are '
        desc += 'required (for example) to create a CNAME to an AWS load balancer.  The load balancer '
        desc += 'A record would be an "external record" in that case.'
        description desc
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'add'
        usage   'add [options] external [properties]'
        summary 'add an external host record'
        desc = 'Adds an external record.  The only required argument is the record itself.  Properties '
        desc += 'are optional and are a string of key value pairs. ie. "foo=bar|baz=biz|buz=boz"'
        description desc

        option :r, :properties, 'Properties to send to proteus on creation', argument: :required

        run do |opts, args|
          exit_2 'External record add requires 1 or more args' unless args.size >= 1
          configure(opts)
          opts[:properties] ||= ''
          ap proteus { |c| c.add_external_host_record(args[0], opts[:properties]) }
        end
      end

      cmd.define_command do
        name 'delete'
        usage   'delete [options] fqdn'
        summary 'delete an external record'

        run do |opts, args|
          exit_2 'External delete requires 1 args' unless args.size == 1
          configure(opts)
          $stdout.puts 'success' if proteus { |c| c.delete_external_record(args[0]) }.nil?
        end
      end

      cmd.define_command do
        name    'search'
        usage   'search [options] term'
        summary 'searches for an external host records'
        desc = 'Searches for host dns records by keyword only. This is the only option for external '
        desc += 'records from the proteus API.'
        description desc

        option :l, :limit, 'How many records to return (max: 10, default: 10)', argument: :required
        option :s, :start, 'Which record to start with, ie. offset (default: 0)', argument: :required

        run do |opts, args|
          exit_2 'Host search requires 1 args' unless args.size == 1
          configure(opts)
          opts[:start] ||= 0
          opts[:limit] ||= 10
          ap proteus { |c| c.search_by_object_types(args[0], Proteus::Types::EXTERNALHOST, opts[:start], opts[:limit]) }
        end
      end

      cmd.define_command do
        name    'show'
        usage   'show [options] fqdn'
        summary 'show an external host record'

        run do |opts, args|
          exit_2 'Host add requires 1 args' unless args.size == 1
          configure(opts)
          ap proteus { |c| c.get_entity_by_name(@config.viewid, args[0], Proteus::Types::EXTERNALHOST) }
        end
      end

      cmd.define_command do
        name    'udf'
        usage   'udf'
        summary 'list user defined fields for external host records'
        flag :r, :required, 'Only return required user defined fields'

        run do |opts, _|
          configure(opts)
          opts[:required] ||= false
          proteus do |c|
            type = Proteus::Types::EXTERNALHOST
            ap Hash[c.get_user_defined_fields(type, opts[:required]).collect { |u| [u.name, u.type] }]
          end
        end
      end
    end
  end
end

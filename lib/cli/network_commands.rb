module ProteusCli
  module NetworkCommands
    def define_root(cmd)
      cmd.define_command do
        name        'network'
        usage       'network [options]'
        summary     'manage networks'
        option :c, :configid, 'Override config id, default gets the first entity in the view', argument: :required
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name    'search'
        usage   'search [options] [hint]'
        summary 'search networks, filter by optional hint (eg. "172.28")'

        run do |opts, args|
          configure(opts)
          proteus do |c|
            hint = args[0].nil? ? '' : "hint=#{args[0]}"
            config_id = c.get_entities.first.id
            start = 0
            batch = 10
            loop do
              result = c.get_ip4_networks_by_hint(config_id, start, batch, hint)
              break if result.nil? || result.empty?
              result.each { |r| ap r }
              start += batch
            end
          end
        end
      end
    end
  end
end

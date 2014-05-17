module NFAgent
  RBConfig = Config

  class Config < SVUtil::Config
    @@test_mode = false

    def self.test_mode?
      @@test_mode
    end

    # Config Options
    # client_key: String, the access key for the client (for the account in normal mode or for a partner in multi mode)
    # dump_dir: String, the directory path of a local spool location
    # pid_file: String, path of process ID file
    # mode: (optional, default: 'normal') String, either 'normal' or 'multi' - can be left blank
    # mapping: Class, this is a plugin class which must be stored in a file in the directory /etc/nfagent/plugins/
    # parse: (optional, default: 'remotely'): String, either 'remotely' or 'locally'
    #
    defaults do |config|
      config.mode             = 'normal'
      config.parse            = 'remotely'
      config.chunk_timeout    = 60
      config.time_zone        = 'UTC'
      config.plugin_directory = '/etc/nfagent/plugins/'
      config.service_host     = 'collector.beta.netfox.com'
      config.service_port     = 80
      config.agent_port       = 10110
    end

    class << self
      def validate
        unless dump_dir and File.exists?(dump_dir) and File.directory?(dump_dir)
          raise "Dump dir (#{dump_dir}) must exist and be a directory"
        end
        # Mode
        unless %w(normal multi).include?(mode)
          raise "Invalid mode: must be one of 'normal' or 'multi'"
        end
        if mode == 'multi' && mapper.blank?
          raise "Multi mode requires a mapper to be set"
        end
        if mode == 'multi' && parse != 'locally'
          raise "Multi mode requires that parsing be done locally (set parse = 'locally')"
        end
        # Parse
        unless %w(remotely locally).include?(parse)
          raise "Invalid parse option: Must be one of 'remotely' or 'locally'"
        end
        super
      end

      def process_options
        parse_options do |opts|
          opts.on("-k", "--client-key [key]", "Service client key") do |key|
            Config.client_key = key
            end
          opts.on("-l", "--debug-log [log-file]", "Debug Log File") do |log|
            Config.log_file = log
          end
          opts.on("-D", "--dump-dir [dir]", "Dump directory for failed chunks") do |dir|
            Config.dump_dir = dir
          end
          opts.on("-T", "--test", "Run connection tests") do
            @@test_mode = true
          end
          opts.on("-P", "--parse", "Parse locally before submitting") do
            Config.parse_locally = true
          end
        end
      end
    end
  end
end

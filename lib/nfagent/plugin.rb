module NFAgent
  class Plugin
    class << self
      def load_plugins
        unless Config.plugin_directory.blank?
          Dir.glob(File.join(Config.plugin_directory, "*.rb")).each do |file|
            load(file)
          end
        end
      end
    end
  end
end

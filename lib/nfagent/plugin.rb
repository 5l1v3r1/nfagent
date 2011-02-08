module NFAgent
  class Plugin
    class << self
      def load_plugins
        if Config.plugin_directory && !Config.plugin_directory.empty? && File.exists?(Config.plugin_directory)
          Dir.glob(File.join(Config.plugin_directory, "*.rb")).each do |file|
            Log.info("Loading plugin: #{file}")
            load(file)
          end
        end
      end
    end
  end
end

module NFAgent
  class Info
    attr_accessor :last_proxy_connection

    def hostname
      Socket.gethostname
    end

    def version
      NFAgent::VERSION
    end

    def host_string
      RBConfig::CONFIG['host']
    end

    def to_hash
      {
        :hostname => hostname,
        :version => version,
        :host_string => host_string,
        :last_proxy_connection => last_proxy_connection
      }
    end
  end
end

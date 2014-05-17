module NFAgent
  class Client
    def self.post(end_point, data_hash)
      Log.info("Submitting to #{Config.service_host} on port #{Config.service_port}")
      proxy_class = Net::HTTP::Proxy(Config.http_proxy_host, Config.http_proxy_port, Config.http_proxy_user, Config.http_proxy_password)
      # TODO: Enable SSL
      proxy_class.start(Config.service_host, Config.service_port) do |http|
        http.read_timeout = 120 # 2 minutes TODO: Make this a config option with 120 as default
        req = Net::HTTP::Post.new("/#{end_point}")
        p({"key" => Config.client_key}.merge(data_hash).delete('data'))
        req.set_form_data({"key" => Config.client_key}.merge(data_hash))
        ClientResponse.new do |resp|
          resp.response, resp.message = http.request(req)
          if !resp.ok?
            Log.info("Client Returned with code (#{resp.response.code}, #{resp.response.msg}) and message '#{resp.message}'")
          end
        end
      end
    rescue Exception => e
      # Trap Exception class here to ensure we catch Timeout
      ClientResponse.new do |resp|
        Log.info("Client Error: #{$!}")
        resp.message = $!
      end
    end
  end
end

module NFAgent
  class Poller
    include EM::Deferrable

    def initialize
      @info = Info.new
    end

    def send_heartbeat
      payload = @info.to_hash
      Log.info("Polling: #{payload.inspect}")
      response = Client.post(:poller, payload)
      if !response.ok?
        Log.error("Poll Failed: #{response.message}")
      end
    end
  end
end

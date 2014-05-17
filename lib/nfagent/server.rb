module NFAgent
  class Server
    def run
      Log.info("Starting up: Listening on port #{Config.agent_port}")
      Log.info("Data will be submitted to #{Config.service_host}:#{Config.service_port}")
      NFAgent::Plugin.load_plugins

      Log.info("Parsing #{Config.parse}")
      Log.info("Mode set to #{Config.mode}")

      chunk_handler = ChunkHandler.new
      poller = Poller.new

      EM.run {
        EM.start_server "0.0.0.0", Config.agent_port, Event, chunk_handler, poller
        EM::PeriodicTimer.new(5) do
          chunk_handler.check_full_or_expired
        end
        EM::PeriodicTimer.new(120) do
          poller.send_heartbeat
        end
        Submitter.run_every(60)
      }
    end

    def shutdown
      EM::stop_event_loop if EM::reactor_running?
    end
  end
end

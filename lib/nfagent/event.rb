module NFAgent
  class Event < EventMachine::Connection
    def initialize(chunk_handler, poller)
      @handler = chunk_handler
      @poller = poller
    end

    def post_init
      Log.info "Client Connected"
    end

    def receive_data(data)
      if data && data.length > 10
        @handler.append(data)
      end
      #send_data('OK')
    end

    def unbind
      Log.info "Disconnected"
    end

    def associate_callback_target(sig)
      # Take no action
    end
  end
end

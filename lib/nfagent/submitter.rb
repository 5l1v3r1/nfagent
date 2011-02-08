module NFAgent
  class Submitter
    include EM::Deferrable
    attr_accessor :host

    def initialize(payload)
      @payload = payload
    end

    def perform
      @payload.increment_attempt!
      fail(@payload) unless [ 1, 2, 4, 8, 16 ].include?(@payload.attempt)
      Log.info "Submitting Payload: #{@payload.checksum}, Attempt #{@payload.attempt}, (#{@payload.size} bytes, #{@payload.line_count} lines)"
      @payload.lock do
        response = Client.post(:collector, @payload.to_hash)
        if response.ok?
          succeed(@payload)
          Log.info("Submitted #{@payload.line_count} lines")
        else
          Log.error "Submission Failed: #{response.message}"
          fail(@payload)
        end
      end
    end

    # Actually runs the submitter
    # every 'seconds' seconds after
    # the last one completes
    def self.run_every(seconds)
      callback = proc { run_every(seconds) }
      EM::add_timer(seconds) do
        EM::defer(nil, callback) do
          resubmit_failed_dumps
        end
      end
    end

    # TODO: Change attempt logic
    # Add the next timestamp for when submission should be attenpted again to the end of the filename 
    def self.resubmit_failed_dumps
      submitter = Submitter.new(Config.client_key)
      dump_dir = Dir.new(Config.dump_dir)
      dump_dir.entries.select { |e| not e =~ /^\./ }.each do |entry|
        Log.info "Resubmitting #{entry}"
        payload = Payload.read_from_file(entry)
        submitter = self.new(payload)
        submitter.callback { |payload|
          payload.destroy!
        }
        submitter.errback { |payload|
          if payload.attempt > 16
            payload.destroy!
          else
            payload.try_again_later
          end
        }
        submitter.perform
      end
    end
  end
end

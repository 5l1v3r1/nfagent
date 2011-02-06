require 'zlib'
require 'digest'

module NFAgent
  class ChunkExpired < StandardError; end
  class ChunkFull < StandardError; end
  class DayBoundary < StandardError; end

  class Chunk < Array
    attr_reader :created_at
    attr_reader :max_size

    DEFAULT_MAX_SIZE = 500

    def initialize(max_size = DEFAULT_MAX_SIZE)
      @max_size = max_size
      @created_at = Time.now
    end

    def <<(line)
      raise ChunkExpired if expired?
      raise ChunkFull if full?
      raise DayBoundary if Time.now.day != self.created_at.day
      super(line)
    end

    def full?
      self.size >= @max_size
    end

    def expired?
      (Time.now - @created_at > Config.chunk_time_out) && !self.empty?
    end

    def dump(key = nil)
      Payload.new do |payload|
        Log.info("Dumping payload from chunk (#{self.size} lines)")
        payload.line_count = self.size
        payload.chunk_expired = expired?
        payload.key = key
        payload.data = Encoder.encode64url(Zlib::Deflate.deflate(self.join("\n"), Zlib::BEST_COMPRESSION))
        payload.checksum = Digest::SHA1.hexdigest(payload.data)
      end
    end

    def submit(key = nil)
      submitter = Submitter.new(self.dump(key))
      submitter.errback { |payload|
        payload.write_to_disk(Config.dump_dir)
      }
      submitter.perform
      # Callback and remove from chunk group
    end
  end
end

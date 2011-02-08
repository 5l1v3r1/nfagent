
module NFAgent
  class Payload < Struct.new(:data, :checksum, :filename, :line_count, :chunk_expired, :key)
    def initialize
      yield self
    end

    def attempt
      @attempt || 0
    end

    def attempt=(value)
      @attempt = value.to_i
    end

    def increment_attempt!
      @attempt ||= 1
      @attempt += 1
    end

    def size
      (self.data || "").size + 1
    end

    def to_hash
      ret = {
        "payload" => self.data,
        "checksum" => self.checksum,
        "line_count" => self.line_count,
        "chunk_expired" => self.chunk_expired
      }
      ret["key"] = self.key unless self.key.blank?
      ret
    end

    def write_to_disk(directory)
      filename = [ self.checksum, self.attempt, self.key ].compact.join("-")
      File.open(File.join(directory, filename), "w") do |file|
        file << self.data
      end
    end

    def lock
      return if locked?
      FileUtils.touch(lockfile) if filename
      yield
      FileUtils.rm_f(lockfile) if filename
    end

    def locked?
      filename && File.exists?(lockfile)
    end

    def self.read_from_file(filename, dir = Config.dump_dir)
      # Ensure the file is only relative
      filename = File.basename(filename)
      self.new do |payload|
        payload.filename = filename
        payload.checksum, payload.attempt, payload.key = filename.split("-")
        payload.data = ""
        ref = File.join(dir, filename)
        File.open(ref, "r") do |file|
          payload.data << file.read
        end
      end
    end

    def destroy!
      FileUtils.rm_f(File.join(Config.dump_dir, self.filename)) if self.filename
    end

    def try_again_later
      # TODO: Move the file to a new name with a later timetamp
      new_filename = [ self.checksum, self.attempt, self.key ].compact.join("-")
      FileUtils.mv(File.join(Config.dump_dir, self.filename), File.join(Config.dump_dir, new_filename))
    end

    private
      def lockfile
        File.join(Config.dump_dir, "#{filename}.lock") if filename
      end
  end
end

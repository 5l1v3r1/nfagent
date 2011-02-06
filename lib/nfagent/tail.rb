##!/usr/bin/env ruby1.9

# NOTE: There is a bug in Ruby 1.8.6p111 which prevents this from working properly - 1.9 is known to work

module LogClient
  class Tail
    class BufferError < StandardError; end

    ::BUFFER_SIZE = 1024
    ::MAX_BUFFER_SIZE = 32768

    def self.tail(filename)
      loop do
        Tail.new(filename).run do |line|
          unless line.nil? || line.empty?
            if block_given?
              yield line
            else
              puts line
            end
          end
        end
      end
    end
  
    def initialize(filename)
      @buffer = ""
      @filename = filename
      reset_buffer_size
      seek_and_setup
    end
  
    # The real work
    # Start at next start. Read until we get a new line and yield the line
    # If we don't get a new line then just ignore and try again until we do
    def run
      begin
        yield @first_line if block_given?
        while (size = File::Stat.new(@filename).size) >= @next_start
          size = @file.stat.size
          reset_buffer_size
          begin
            line = ""
            @file.seek(@next_start, File::SEEK_SET)
            @file.read(@buf_size, @buffer)
            buffer_start = @next_start
            found_new_line = false
            0.upto(@buffer.size - 1) do |index|
              line << @buffer[index]
              if @buffer[index].chr == "\n"
                yield(line) if block_given?
                line = ""
                found_new_line = true
                @next_start = buffer_start + index + 1
              end
            end
            unless found_new_line || @buffer.empty?
              raise BufferError
            end
          rescue BufferError
            increment_buffer_size
            retry
          end
	  sleep 0.01
        end
      rescue Errno::ENOENT
        # Wait until the file is recreated
        while !File.exists?(@filename)
          sleep 0.05
        end
      end
    end
  
    private
      def seek_and_setup
        @file = File.open(@filename, "r+")
        size = @file.stat.size
        pos = size
        begin
          if size >= @buf_size
            @file.seek(size - @buf_size, File::SEEK_SET)
          end
          @buffer = @file.read
          if @buffer.size > 0
            index = @buffer.size - 1
            # Find the last new line in the @buffer
            # Make sure we got a new line somewhere
            while (char = @buffer[index].chr) != "\n" && index >= 0
              index -= 1
            end
            # Start reading from here next time
            @next_start = pos - (@buf_size - index) + 1
            @next_start = 0 if @next_start < 0
            line = ""
            if index > 1
              index -= 1
              # Go back to the previous new line (or the start of the @buffer)
              while (char = @buffer[index].chr) != "\n"
                line << char
                index -= 1
              end
            end
            # If index is 0 and the buffer is smaller than the file
            # then we can try reading more chars until we find a new line
            if index <= 0 and @buf_size < size
              raise BufferError
            end
            @first_line = line.reverse
          else
            @next_start = pos
          end
        rescue BufferError
          increment_buffer_size
          retry
        end
      end

      def increment_buffer_size
        @buf_size = @buf_size * 2
        if @buf_size > ::MAX_BUFFER_SIZE
          raise BufferError, "Maximum buffer size exceeded"
        end
      end
  
      def reset_buffer_size
        @buf_size = ::BUFFER_SIZE
      end
  end
end

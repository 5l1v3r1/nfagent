module NFAgent
  class Tests
    def self.run
      response = Client.post(:poller, Info.new.to_hash)
      if !response.ok?
        puts "Test Failed: #{response.message}"
      else
        puts "Tests PASSED!"
      end
    end
  end
end

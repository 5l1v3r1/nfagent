module NFAgent
  class ClientResponse
    attr_accessor :response, :message

    def initialize
      yield self if block_given?
    end

    def ok?
      Net::HTTPOK === response
    end
  end
end

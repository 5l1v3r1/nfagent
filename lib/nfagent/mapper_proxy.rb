module NFAgent
  class MapperProxy
    class << self
      def instance
        return @instance if @instance
        raise "No Mapper Set" if Config.mapper.blank?
        @instance = Config.mapper.constantize.new
      end

      # TODO: Can we delegate?
      def find_account_id(username, client_ip)
        instance.find_account_id(username, client_ip)
      end

      # TODO: before shutdown
    end
  end
end

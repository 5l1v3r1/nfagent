module NFAgent
  class Base64
    def self.encode64url(str)
      [str].pack('m').tr("+/","-_")
    end
  end
end

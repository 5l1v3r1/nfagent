module NFAgent
  class Encoder
    def self.encode64url(str)
      [str].pack('m').tr("+/","-_")
    end
  end
end

class MyMapper
  def initialize
    @hash = {
      'dan' => 'acme',
      'paul' => 'jetson',
      'mike' => 'acme'
    }
  end

  def before_shutdown
    # Put any cleanup code in here
  end

  def find_account_id(username, client_ip)
    raise NFAgent::IgnoreLine if username == 'andrew'
    @hash[username]
  end
end

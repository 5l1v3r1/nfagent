
require 'test/test_helper'

class TestMapperProxy < ActiveSupport::TestCase
  setup do
    NFAgent::Config.plugin_directory = File.dirname(__FILE__) + '/../test/plugins/' 
  end

  test "instantiate just once" do
    MyMapper.expects(:new).at_most_once
    NFAgent::Config.mapper = nil
    NFAgent::MapperProxy.instance
    NFAgent::MapperProxy.instance
    NFAgent::MapperProxy.instance
  end

  test "mapper method" do
    assert_equal 'acme', NFAgent::MapperProxy.find_account_id('dan', '192.168.0.10')
  end
end

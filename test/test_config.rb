
require 'test/test_helper'

class TestConfig < ActiveSupport::TestCase
  setup do
    NFAgent::Config.attrs.clear
  end

  test "defaults" do
    puts "HHHHHH"
    p NFAgent::Config.attrs
    assert_equal "normal", NFAgent::Config.mode
    assert_equal "remotely", NFAgent::Config.parse
    assert_equal 60, NFAgent::Config.chunk_timeout
    assert_equal 'UTC',  NFAgent::Config.time_zone
    assert_equal '/etc/nfagent/plugins/', NFAgent::Config.plugin_directory
  end

  test "validates valid mode" do
    NFAgent::Config.mode = 'some stupid thing'
    assert_raises(RuntimeError) { NFAgent::Config.validate }
  end

  test "validates mapping with multi" do
    NFAgent::Config.attrs.clear
    NFAgent::Config.config_file = "test/config"
    NFAgent::Config.init

    NFAgent::Config.mode = 'multi'
    assert_raises(RuntimeError) { NFAgent::Config.validate }
    NFAgent::Config.mapper = 'AccountMapper'
    assert_raises(RuntimeError) { NFAgent::Config.validate }
    NFAgent::Config.parse = 'locally'
    assert NFAgent::Config.validate
  end

  test "validates valid parse option" do
    NFAgent::Config.attrs.clear
    NFAgent::Config.config_file = "test/config"
    NFAgent::Config.init

    NFAgent::Config.parse = 'some stupid thing'
    assert_raises(RuntimeError) { NFAgent::Config.validate }
    NFAgent::Config.parse = 'locally'
    assert NFAgent::Config.validate
    NFAgent::Config.parse = 'remotely'
    assert NFAgent::Config.validate
  end
end

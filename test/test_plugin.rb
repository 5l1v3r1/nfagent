
require 'test/test_helper'

class TestPlugin < ActiveSupport::TestCase
  setup do
  end

  test "load" do
    assert_raise(NameError) { "MissingMapper".constantize }
    NFAgent::Plugin.load_plugins
    "MyMapper".constantize
  end
end

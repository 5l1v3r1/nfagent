
require 'test/test_helper'

class TestPlugin < ActiveSupport::TestCase
  setup do
  end

  test "load" do
    assert_raise(NameError) { Object.const_get("MissingMapper") }
    NFAgent::Plugin.load_plugins
    Object.const_get("MyMapper")
  end
end

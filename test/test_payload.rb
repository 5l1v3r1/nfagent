
require 'test/test_helper'

class TestPayload < ActiveSupport::TestCase
  setup do
  end

  test "to_hash" do
    payload = NFAgent::Payload.new do |p|
      p.data = "data"
      p.checksum = "checksum"
      p.line_count = 10
      p.chunk_expired = false
    end
    assert_equal({ 'payload' => 'data', 'checksum' => 'checksum', 'line_count' => 10, 'chunk_expired' => false }, payload.to_hash)
    # Check key
    payload = NFAgent::Payload.new do |p|
      p.data = "data"
      p.checksum = "checksum"
      p.line_count = 10
      p.chunk_expired = false
      p.key = '1234'
    end
    assert_equal({ 'payload' => 'data', 'checksum' => 'checksum', 'line_count' => 10, 'chunk_expired' => false, 'key' => '1234' }, payload.to_hash)
  end
end

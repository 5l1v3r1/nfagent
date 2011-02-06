
require 'test/test_helper'

class TestClient < ActiveSupport::TestCase
  setup do
  end

  test "post data with configured client key" do
    Net::HTTP::Post.any_instance.expects(:set_form_data).with({ 'payload' => 'data', 'checksum' => 'checksum', 'line_count' => 10, 'chunk_expired' => false, 'key' => '1234' })
    hash = { 'payload' => 'data', 'checksum' => 'checksum', 'line_count' => 10, 'chunk_expired' => false }
    NFAgent::Client.post(:collector, hash)
  end

  test "post data with key passed in data hash" do
    Net::HTTP::Post.any_instance.expects(:set_form_data).with({ 'payload' => 'data', 'checksum' => 'checksum', 'line_count' => 10, 'chunk_expired' => false, 'key' => 'abcd' })
    hash = { 'payload' => 'data', 'checksum' => 'checksum', 'line_count' => 10, 'chunk_expired' => false, 'key' => 'abcd' }
    NFAgent::Client.post(:collector, hash)
  end

end

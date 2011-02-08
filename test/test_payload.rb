
require 'test/test_helper'

class TestPayload < ActiveSupport::TestCase
  setup do
    FileUtils.rm_f(Dir.glob("test/sandbox/dumps/*"))
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

  test "write-to-disk" do
    payload = NFAgent::Payload.new do |p|
      p.data = "data"
      p.checksum = "checksum"
      p.line_count = 10
      p.chunk_expired = false
    end
    payload.write_to_disk("test/sandbox/dumps")
    assert File.exists?("test/sandbox/dumps/checksum-0")
    # And read back in
    payload = NFAgent::Payload.read_from_file("checksum-0", "test/sandbox/dumps/")
    assert_equal "data", payload.data
    assert_equal 0, payload.attempt
    assert !payload.key
  end

  test "write-to-disk with non-zero attempt number" do
    payload = NFAgent::Payload.new do |p|
      p.data = "data"
      p.checksum = "checksum"
      p.line_count = 10
      p.chunk_expired = false
      p.attempt = 10
    end
    payload.write_to_disk("test/sandbox/dumps")
    assert File.exists?("test/sandbox/dumps/checksum-10")
    # And read back in
    payload = NFAgent::Payload.read_from_file("checksum-10", "test/sandbox/dumps/")
    assert_equal "data", payload.data
    assert_equal 10, payload.attempt
  end

  test "write-to-disk with key" do
    payload = NFAgent::Payload.new do |p|
      p.data = "data"
      p.checksum = "checksum"
      p.line_count = 10
      p.chunk_expired = false
      p.key = '1234'
    end
    payload.write_to_disk("test/sandbox/dumps")
    assert File.exists?("test/sandbox/dumps/checksum-0-1234")
    # And read back in
    payload = NFAgent::Payload.read_from_file("checksum-0-1234", "test/sandbox/dumps/")
    assert_equal "data", payload.data
    assert_equal 0, payload.attempt
    assert_equal '1234', payload.key
  end

end

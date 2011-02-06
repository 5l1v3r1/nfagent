#!/usr/bin/env ruby

require 'benchmark'

require 'log-file/parser'
require 'log-file/chunk'

chunk = LogClient::Chunk.new(1000)
LogClient::Parser::SquidStandardParser.new(ARGV[0]).run do |line|
  chunk << line
  if chunk.full?
    puts chunk.dump
    exit
  end
end

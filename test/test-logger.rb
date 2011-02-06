#!/usr/bin/env ruby

max_len = 0
File.open("/tmp/test-out.log", "w+") do |out|
  File.new(ARGV[0]).each_line do |line|
    out << line
    if line.length > max_len
      max_len = line.length
    end
    #sleep 0.01
  end
end

puts max_len

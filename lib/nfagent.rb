$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'active_support'
require 'svutil'
require 'squiggle'

require 'fileutils'
require 'logger'
require 'pp'
require 'uri'
require 'net/http'
require 'eventmachine'
require 'em/timers'
require 'rbconfig'

require 'nfagent/object_extra'
require 'nfagent/chunk'
require 'nfagent/client'
require 'nfagent/client_response'
require 'nfagent/chunk_handler'
require 'nfagent/mapper_proxy'
require 'nfagent/plugin'
require 'nfagent/submitter'
require 'nfagent/encoder'
require 'nfagent/config'
require 'nfagent/log'
require 'nfagent/info'
require 'nfagent/payload'
require 'nfagent/poller'
require 'nfagent/tail'
require 'nfagent/event'
require 'nfagent/server'
require 'nfagent/cli'
require 'nfagent/tests'

module NFAgent
  VERSION = '0.9.29'
end

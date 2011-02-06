# Use this to build a Windows exe
# ocra nfagent.rb
# (gem install ocra)
#

require 'rubygems'
require 'nfagent'

if not defined?(Ocra)
  NFAgent::CLI.new
end

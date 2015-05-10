#!/usr/bin/env ruby

# Listens for connections, asynchronously receives data, replies with
# pretty-printed arrays (works for indefinite arrays with integers only for
# the sake of simplicity)
#
# Make sure to install EventMachine first (`$ gem install eventmachine`)
#
# Start with
# $ ./examples/network_streaming.rb
#
# Then send data from the example file using netcat or a similar tool:
# $ netcat localhost 9000 < examples/data/indef_array.cbor
#
# The file from the example contains the CBOR representation of
#   [_ [_ 1, 2], 3, [_ 4, [_ 5]]]
# Terminate with ^c

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'lib/libcbor'
require 'rubygems'
require 'eventmachine'

class CBORPrinter < EM::Connection
	def print(what)
		send_data('  ' * @nesting + what.to_s + "\n")
	end

	def initialize
		@nesting = 0
		@reader = CBOR::Streaming::BufferedDecoder.new(
			array_start: ->() { print '['; @nesting += 1 },
			integer: ->(val) { print val },
			break: ->() {
				@nesting -= 1; print ']'
				close_connection_after_writing if @nesting == 0
			}
		)
	end

	def receive_data(data)
		@reader << data
	end
end

EventMachine.run do
	Signal.trap('INT')  { EventMachine.stop }
	EventMachine.start_server('0.0.0.0', 9000, CBORPrinter)
end
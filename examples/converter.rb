#!/usr/bin/env ruby

# CBOR <-> JSON converter. Works for compatible constructs only.
# Make sure to install trollop (`$ gem install trollop`) before using this.
#
# Usage:
# $ cat examples/data/indef_array.cbor | ./examples/converter.rb | ./examples/converter.rb --to-cbor | ./examples/converter.rb
 
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'lib/libcbor'
require 'trollop'
require 'json'

CBOR.load!

opts = Trollop::options do
	banner <<-EOS
Converts between JSON and CBOR. Uses STDIN and STDOUT for I/O

Usage:
       converter [options]

where [options] are:
	EOS

	opt :to_json,
		'Convert from CBOR to JSON. Otherwise, convert from JSON to CBOR',
		default: true
	opt :to_cbor,
		'Convert from JSON to CBOR',
		default: false
end
opts[:to_json] = !opts[:to_cbor]

if opts[:to_json]
	puts CBOR.decode($stdin.read).to_json
else
	print CBOR.encode(JSON.load($stdin.read))
end


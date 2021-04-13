# libcbor

[![Build Status](https://travis-ci.org/PJK/libcbor-ruby.svg?branch=master)](https://travis-ci.org/PJK/libcbor-ruby)
[![Coverage Status](https://coveralls.io/repos/PJK/libcbor-ruby/badge.svg?branch=master)](https://coveralls.io/r/PJK/libcbor-ruby?branch=master)

**libcbor-ruby is deprecated and not actively maintained**

The Ruby bindings for [libcbor](https://github.com/PJK/libcbor). Provides [CBOR](http://cbor.io/)
encoding and decoding features, including streaming.

## Important resources

 - [libcbor](http://libcbor.org/)
 - [API reference](http://www.rubydoc.info/gems/libcbor/)
 - [git repository](https://github.com/PJK/libcbor-ruby)
 - [rubygems.org page](https://rubygems.org/gems/libcbor)

## Installation

Make sure that `libffi-dev` and `libcbor` are present on your system.

Add this line to your application's Gemfile:

```ruby
gem 'libcbor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libcbor

## Usage

Include the library using

```ruby
include 'libcbor/all'
```

You can then encode objects

```ruby
{ 'key' => 42 }.to_cbor
# => "\xA1ckey\x18*"
```

... as well as decode serialized data

```ruby
CBOR.decode("\xA1ckey\x18*")
# => {"key"=>42}
```

*libcbor* also comes with streaming features. When decoding, you can specify
callbacks and handle the input as desired. The following example illustrates
how to integrate *libcbor* with [EventMachine](https://github.com/eventmachine/eventmachine):

```ruby
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
```

Streaming encoding is possible as well. Check out the `examples` directory and the
[documentation]() for more examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/libcbor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License

The MIT License (MIT)

Copyright (c) Pavel Kalvoda, 2015

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

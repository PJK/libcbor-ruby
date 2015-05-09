#!/usr/bin/env ruby

# Load all CBOR files passed as arguments and prints the result.
# Example usage:
# $ ./examples/load_file.rb examples/data/*

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'lib/libcbor'
require 'pp'

ARGV.each { |_| PP.pp  CBOR.decode(IO.read(_)) }
require 'spec_helper'

module CBOR
	module Streaming
		describe Encoder do
			let(:target) { StringIO.new }
			subject { Encoder.new(target) }

			it 'produces correct CBOR data' do
				subject.start_array
				subject << 1
				subject << 2
				subject.break

				expect(CBOR.decode(target.string)).to eq [1, 2]
			end

			it 'encodes maps' do
				subject.start_map
				subject.break
				expect(CBOR.decode(target.string)).to eq Hash.new
			end

			it 'encodes strings' do
				subject.start_chunked_string
				subject << 'Hello '
				subject << 'World'
				subject.break
				expect(CBOR.decode(target.string)).to eq 'Hello World'
			end

			it 'encodes byte strings' do
				subject.start_chunked_byte_string
				subject << ByteString.new('Hello ')
				subject << ByteString.new('World')
				subject.break
				expect(CBOR.decode(target.string)).to eq 'Hello World'
			end

			it 'encodes tags' do
				subject.tag(5)
				subject << 42
				expect(CBOR.decode(target.string)).to eq Tag.new(5, 42)
			end
		end
	end
end
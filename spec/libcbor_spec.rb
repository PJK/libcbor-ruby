require 'spec_helper'

describe CBOR do
  it 'has a version number' do
    expect(CBOR::VERSION).not_to be nil
	end

	it 'encodes simple values' do
		expect(CBOR.encode(3)).to eq "\x3"
	end
end

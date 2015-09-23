require 'spec_helper'

require 'sorted/json_query'

describe Sorted::JSONQuery, 'decode' do
  it 'should return a nice array from the order sql' do
    json = { 'email' => 1, 'phone' => 1, 'name' => -1 }
    set = Sorted::JSONQuery.parse(json)
    result = Sorted::Set.new([['email', 'asc'], ['phone', 'asc'], ['name', 'desc']])

    expect(set).to eq(result)
  end
end

describe Sorted::JSONQuery, 'encode' do
  it 'should return an sql sort string' do
    set = Sorted::Set.new([['email', 'desc'], ['name', 'desc'], ['phone', 'asc']])
    result = { 'email' => -1, 'phone' => 1, 'name' => -1 }

    expect(Sorted::JSONQuery.encode(set)).to eq(result)
  end
end

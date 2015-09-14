require 'spec_helper'

describe Sorted::ElasticsearchQuery, 'decode' do
  it 'should return a nice array from the order sql' do
    json = { 'email' => {'order' => 'desc'}, 'phone' => {'order' => 'asc'}, 'name' => {'order' => 'desc'} }
    set = Sorted::ElasticsearchQuery.parse(json)
    result = Sorted::Set.new([['email', 'desc'], ['phone', 'asc'], ['name', 'desc']])

    expect(set).to eq(result)
  end
end

describe Sorted::ElasticsearchQuery, 'encode' do
  it 'should return an sql sort string' do
    set = Sorted::Set.new([['email', 'desc'], ['name', 'desc'], ['phone', 'asc']])
    result = { 'email' => {'order' => 'desc'}, 'phone' => {'order' => 'asc'}, 'name' => {'order' => 'desc'} }

    expect(Sorted::ElasticsearchQuery.encode(set)).to eq(result)
  end
end

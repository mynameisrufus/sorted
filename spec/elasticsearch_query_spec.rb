require 'spec_helper'

describe Sorted::ElasticsearchQuery, 'decode' do
  it 'should decode elasticsearch order hash to into set' do
    json = [{ 'email' => { 'order' => 'desc' } }, { 'phone' => { 'order' => 'asc' } }, { 'name' => { 'order' => 'desc' } }]
    set = Sorted::ElasticsearchQuery.parse(json)
    result = Sorted::Set.new([['email', 'desc'], ['phone', 'asc'], ['name', 'desc']])

    expect(set).to eq(result)
  end
end

describe Sorted::ElasticsearchQuery, 'encode' do
  it 'should encode set into elasticsearch order hash' do
    set = Sorted::Set.new([['email', 'desc'], ['phone', 'asc'], ['name', 'desc']])
    result = [{ 'email' => { 'order' => 'desc' } }, { 'phone' => { 'order' => 'asc' } }, { 'name' => { 'order' => 'desc' } }]

    expect(Sorted::ElasticsearchQuery.encode(set)).to eq(result)
  end
end

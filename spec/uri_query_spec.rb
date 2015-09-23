require 'spec_helper'

require 'sorted/uri_query'

describe Sorted::URIQuery, 'decode' do
  it 'should allow numbers, underscores and full stops in sort params' do
    uri = 'assessmentsTable.name_desc!users_300.name_5_desc'
    set = Sorted::URIQuery.parse(uri)
    result = [['assessmentsTable.name', 'desc'], ['users_300.name_5', 'desc']]

    expect(set).to eq(result)
  end
end

describe Sorted::URIQuery, 'encode' do
  it 'should return a nice array from the sort params' do
    set = Sorted::Set.new([['email', 'desc'], ['name', 'desc'], ['phone', 'asc']])
    result = 'email_desc!name_desc!phone_asc'

    expect(Sorted::URIQuery.encode(set)).to eq(result)
  end
end

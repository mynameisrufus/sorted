require 'spec_helper'

require 'sorted/params_query'

describe Sorted::ParamsQuery, 'decode' do
  it 'should return a set from an array of params' do
    params = %w(email_asc phone_asc name_desc)
    set = Sorted::ParamsQuery.parse(params)
    result = Sorted::Set.new([['email', 'asc'], ['phone', 'asc'], ['name', 'desc']])

    expect(set).to eq(result)
  end

  it 'should defalut to asc if missing direction' do
    params = %w(email)
    set = Sorted::ParamsQuery.parse(params)
    result = Sorted::Set.new([['email', 'asc']])

    expect(set).to eq(result)
  end
end

describe Sorted::ParamsQuery, 'encode' do
  it 'should return an array of params to be used with a URL library' do
    set = Sorted::Set.new([['email', 'desc'], ['name', 'desc'], ['phone', 'asc']])
    result = %w(email_desc name_desc phone_asc)

    expect(Sorted::ParamsQuery.encode(set)).to eq(result)
  end
end

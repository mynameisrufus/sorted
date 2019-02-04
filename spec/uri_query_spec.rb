require 'spec_helper'

require 'sorted/uri_query'

describe Sorted::URIQuery, 'decode' do
  it 'should allow numbers, underscores and full stops in sort params' do
    uri = 'assessmentsTable.name_desc!users_300.name_5_desc'
    set = Sorted::URIQuery.parse(uri)
    result = [['assessmentsTable.name', 'desc'], ['users_300.name_5', 'desc']]

    expect(set).to eq(result)
  end

  it 'should decode nulls first/last' do
    uri = 'table_name.column_name_desc_nulls_last!table_name.column_name_5_asc_nulls_first'
    set = Sorted::URIQuery.parse(uri)
    result = [['table_name.column_name', 'desc', 'nulls_last'], ['table_name.column_name_5', 'asc', 'nulls_first']]

    expect(set).to eq(result)
  end

  it 'should decode nulls first/last without asc/desc' do
    uri = 'table_name.column_name_nulls_last!table_name.column_name_5_nulls_first'
    set = Sorted::URIQuery.parse(uri)
    result = [['table_name.column_name', 'nulls_last'], ['table_name.column_name_5', 'nulls_first']]

    expect(set).to eq(result)
  end
end

describe Sorted::URIQuery, 'encode' do
  it 'should return a nice array from the sort params' do
    set = Sorted::Set.new([['email', 'desc'], ['name', 'desc'], ['phone', 'asc']])
    result = 'email_desc!name_desc!phone_asc'

    expect(Sorted::URIQuery.encode(set)).to eq(result)
  end

  it 'should encode nulls first/last' do
    set = Sorted::Set.new([%w[column_name desc nulls_last], %w[column_name_5 asc nulls_first]])
    result = 'column_name_desc_nulls_last!column_name_5_asc_nulls_first'

    expect(Sorted::URIQuery.encode(set)).to eq(result)
  end

  it 'should encode nulls first/last' do
    set = Sorted::Set.new([%w[column_name nulls_last], %w[column_name_5 nulls_first]])
    result = 'column_name_nulls_last!column_name_5_nulls_first'

    expect(Sorted::URIQuery.encode(set)).to eq(result)
  end
end

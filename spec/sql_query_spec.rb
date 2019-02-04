require 'spec_helper'

require 'sorted/sql_query'

describe Sorted::SQLQuery, 'decode' do
  it 'should return a nice array from the order sql' do
    sql = 'email ASC, phone ASC, name DESC'
    set = Sorted::SQLQuery.parse(sql)
    result = Sorted::Set.new([['email', 'asc'], ['phone', 'asc'], ['name', 'desc']])

    expect(set).to eq(result)
  end

  it 'should allow numbers, underscores and full stops in order params' do
    sql = 'assessmentsTable.name ASC, users_300.name_5 ASC'
    set = Sorted::SQLQuery.parse(sql)
    result = Sorted::Set.new([['assessmentsTable.name', 'asc'], ['users_300.name_5', 'asc']])

    expect(set).to eq(result)
  end

  it 'should default to asc if sort params order is ommited' do
    sql = :email
    set = Sorted::SQLQuery.parse(sql)
    result = [['email', 'asc']]

    expect(set).to eq(result)
  end

  it 'sql injection using order by clause should not work' do
    sql = '(case+when+((ASCII(SUBSTR((select+table_name+from+all_tables+where+rownum%3d1),1))>%3D128))+then+id+else+something+end)'
    set = Sorted::SQLQuery.parse(sql)
    result = Sorted::Set.new([['case', 'asc'], ['1', 'asc']])

    expect(set).to eq(result)
  end

  it 'should decode nulls first/last' do
    sql = 'email ASC NULLS FIRST, phone ASC, name DESC NULLS LAST'
    set = Sorted::SQLQuery.parse(sql)
    result = Sorted::Set.new([['email', 'asc', 'nulls first'], ['phone', 'asc'], ['name', 'desc', 'nulls last']])

    expect(set).to eq(result)
  end

  it 'should decode nulls first/last without asc/desc' do
    sql = 'email NULLS FIRST, phone, name NULLS LAST'
    set = Sorted::SQLQuery.parse(sql)
    result = Sorted::Set.new([['email', 'nulls first'], ['phone', 'asc'], ['name', 'nulls last']])

    expect(set).to eq(result)
  end
end

describe Sorted::SQLQuery, 'encode' do
  module FakeConnection
    def self.quote_column_name(column_name)
      "`#{column_name}`"
    end
  end

  let(:quoter) { ->(frag) { FakeConnection.quote_column_name(frag) } }

  it 'should properly escape sql column names' do
    set = Sorted::Set.new([['users.name', 'desc']])
    result = '`users`.`name` DESC'

    expect(Sorted::SQLQuery.encode(set, quoter)).to eq(result)
  end

  it 'should return an sql sort string' do
    set = Sorted::Set.new([['email', 'desc'], ['name', 'desc'], ['phone', 'asc']])
    result = '`email` DESC, `name` DESC, `phone` ASC'

    expect(Sorted::SQLQuery.encode(set, quoter)).to eq(result)
  end

  it 'should encode nulls first/last' do
    set = Sorted::Set.new([['email', 'desc', 'nulls_last'], ['name', 'desc'], ['phone', 'asc', 'nulls_first']])
    result = '`email` DESC NULLS LAST, `name` DESC, `phone` ASC NULLS FIRST'

    expect(Sorted::SQLQuery.encode(set, quoter)).to eq(result)
  end

  it 'should encode nulls first/last without asc/desc' do
    set = Sorted::Set.new([['email', 'nulls_last'], ['name'], ['phone', 'nulls_first']])
    result = '`email` NULLS LAST, `name`, `phone` NULLS FIRST'

    expect(Sorted::SQLQuery.encode(set, quoter)).to eq(result)
  end
end

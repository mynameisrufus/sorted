require 'spec_helper'

describe Sorted::Set do
  it 'should bring phone to first order importance but not toggle ascendance' do
    orders = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    sorts  = Sorted::Set.new([['phone', 'asc']])
    result = Sorted::Set.new([['phone', 'asc'], ['email', 'asc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should toggle ascendance of email' do
    orders = Sorted::Set.new([['email', 'desc']])
    sorts = Sorted::Set.new([['email', 'asc']])
    result = Sorted::Set.new([['email', 'desc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should return both order params un-toggled with no sort param' do
    orders = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    sorts = Sorted::Set.new([])
    result = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should toggle the email ascendance' do
    orders = Sorted::Set.new([['email', 'asc']])
    sorts = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    result = Sorted::Set.new([['email', 'desc'], ['phone', 'asc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should toggle the email ascendance' do
    orders = Sorted::Set.new([['email', 'desc']])
    sorts = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    result = Sorted::Set.new([['email', 'desc'], ['phone', 'asc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should toggle two 1..n sort values' do
    orders = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    sorts = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    result = Sorted::Set.new([['email', 'desc'], ['phone', 'desc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should toggle based on sorts and not orders' do
    orders = Sorted::Set.new([['email', 'desc'], ['phone', 'desc']])
    sorts = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    result = Sorted::Set.new([['email', 'desc'], ['phone', 'desc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should toggle based on sorts and not orders' do
    orders = Sorted::Set.new([['email', 'asc']])
    sorts = Sorted::Set.new([['name', 'asc']])
    result = Sorted::Set.new([['email', 'asc'], ['name', 'asc']])

    expect(orders.direction_intersect(sorts)).to eq(result)
  end

  it 'should return a hash' do
    set = Sorted::Set.new([['email', 'asc']])
    result = { 'email' => 'asc' }

    expect(set.to_hash).to eq(result)
  end
end

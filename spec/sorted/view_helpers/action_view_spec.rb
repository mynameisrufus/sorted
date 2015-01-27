require 'spec_helper'

describe Sorted::ViewHelpers::ActionView do
  it 'should integrate with ActiveRecord::Base' do
    ActionView::Base.send(:include, Sorted::ViewHelpers::ActionView)
    ActionView::Base.new.should respond_to(:link_to_sorted)
  end
end

describe Sorted::ViewHelpers::ActionView::SortedViewHelper do
  it 'should return the default sort order and preserve the existing params' do
    order  = :email
    params = { page: 10 }
    result = { page: 10, sort: 'email_asc' }

    sorter = Sorted::ViewHelpers::ActionView::SortedViewHelper.new order, params
    sorter.params.should eq result
  end

  it 'should only return the sorted css class if email has not yet been sorted' do
    order  = :email
    params = {}
    result = 'sorted'

    sorter = Sorted::ViewHelpers::ActionView::SortedViewHelper.new order, params
    sorter.css.should eq result
  end

  it 'should only return the sorted css class if email has not yet been sorted' do
    order  = :email
    params = { sort: 'email_asc' }
    result = 'sorted asc'

    sorter = Sorted::ViewHelpers::ActionView::SortedViewHelper.new order, params
    sorter.css.should eq result
  end

  it 'should return the default order when params are empty' do
    order  = :email
    result = { sort: 'email_asc' }

    sorter = Sorted::ViewHelpers::ActionView::SortedViewHelper.new order, {}
    sorter.params.should eq result
  end

  it 'should correctly toggle multiple params' do
    order  = 'email DESC, name DESC'
    params = { sort: 'email_asc!name_asc' }
    result = { sort: 'email_desc!name_desc' }

    sorter = Sorted::ViewHelpers::ActionView::SortedViewHelper.new order, params
    sorter.params.should eq result
  end

  it 'should have sort order over existing params' do
    order  = :email
    params = { sort: 'name_asc' }
    result = { sort: 'email_asc!name_asc' }

    sorter = Sorted::ViewHelpers::ActionView::SortedViewHelper.new order, params
    sorter.params.should eq result
  end
end

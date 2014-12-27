# sorted

[![Build Status](https://travis-ci.org/mynameisrufus/sorted.svg?branch=master)](https://travis-ci.org/mynameisrufus/sorted)
[![Gem Version](https://badge.fury.io/rb/sorted.svg)](http://badge.fury.io/rb/sorted)

Sorted at it's core is a set of objects that let you sort many different
attributes in weird and wonderful ways.

## Example

The secret sauce is the `Sorted::Set` object, in this example we 'toggle' email:

```ruby
a = Sorted::Set.new([['email', 'asc'], ['name', 'asc']])
b = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])

s = a.direction_intersect(b) + (a - b) + (b - a)

s.uniq.to_a #=> [['email', 'desc'], ['phone', 'asc'], ['name', 'asc']]
```

The best way to think about this is to imagine a spreed sheet and what happens
when you sort by various columns, `Sorted::Set` pretty much just does that.

## Parsers/Encoders

Parsers return a `Sorted::Set` that can then be used by an encoder:

```ruby
set = Sorted::URIQuery.parse('name_asc!email_asc')
Sorted::SQLQuery.encode(set) #=> 'name ASC email ASC'
```

Currently implemented:

* `Sorted::SQLQuery`
* `Sorted::URIQuery`

TODO:

* `Sorted::JSONQuery` (Mongoid)

## Rails

Sorted comes with `ActionView` helpers and ORM scopes out of the box.

The ORM scopes will let you sort large datasets over many pages (using
[will_paginate](https://github.com/mislav/will_paginate) or 
[kaminari](https://github.com/amatsuda/kaminari)) without losing state.

### View

Generate a sorted link with the email attribute:

```ruby
link_to_sorted "Email", :email
```

Works the same as the `link_to` method except a second argument for the
sort attribute is needed.

### Model

Using the `sorted` method with the optional default order argument:

```ruby
@users = User.sorted(params[:sort], "email ASC").page(params[:page])
```

A `resorted` method is also available and works the same way as the `reorder` method in Rails.
It forces the order to be the one passed in:

```ruby
@users = User.order(:id).sorted(nil, 'name DESC').resorted(params[:sort], 'email ASC')
```

## Supported ORMs

* ActiveRecord
* Mongoid

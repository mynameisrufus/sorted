# sorted

[![Build Status](https://travis-ci.org/mynameisrufus/sorted.svg?branch=master)](https://travis-ci.org/mynameisrufus/sorted)

Sorted at it's core is a set of objects that let you sort many different
attributes in weird and wonderful ways.

## Example

The secret sauce is the `Sorted::Set` object, in this example we 'toggle' email:

```ruby
a = Sorted::Set.new([['email', 'asc'], ['name', 'asc']])
b = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])

s = a.direction_intersect(b)

s.to_a #=> [['email', 'desc'], ['phone', 'asc'], ['name', 'asc']]
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
* `Sorted::JSONQuery`

## Projects

* Mongoid https://github.com/dleavitt/sorted-mongoid

TODO:

* ActiveRecord
* ActionView

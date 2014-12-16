require 'sorted/parser'

module Sorted
  class Set
    def initialize(set = [])
      @set = set
    end

    def each(&block)
      @set.each(&block)
    end

    def direction_intersect(other)
      memo = []
      each.with_index do |a, i|
        b = other.at(i)
        next unless b
        memo << (b.first == a.first ? [a.first, flip_direction(a.last)] : a)
      end
      self.class.new(memo)
    end

    def -(other)
      memo = []
      each do |a|
        b = other.assoc(a.first)
        next if b
        memo << a
      end
      self.class.new(memo)
    end

    def +(other)
      self.class.new(@set + other.to_a)
    end

    def <<(a)
      self.class.new(@set << a)
    end

    def assoc(o)
      @set.assoc(o)
    end

    def at(i)
      @set.at(i)
    end

    def to_a
      @set
    end

    def to_hash
      @set.inject({}) { |a, e| a.merge(Hash[e[0], e[1]]) }
    end

    def flip_direction(direction)
      case direction
      when 'asc' then 'desc'
      when 'desc'then  'asc'
      end
    end
  end

  module Parse
    def split(raw, delim, &block)
      return Set.new if raw.nil?
      raw.to_s.split(delim).inject(Set.new, &block)
    end
  end

  class URIQuery
    extend Parse

    REGEXP = /([a-zA-Z0-9._]+)_(asc|desc)$/

    def self.parse(raw)
      split(raw, /!/) do |set, part|
        m = part.match(REGEXP)
        return set unless m
        set << [m[1], m[2].downcase]
      end
    end

    def self.encode(set)
      set.map { |a| a.join('_') }.join('!')
    end
  end

  class SQLQuery
    extend Parse

    REGEXP = /(([a-z0-9._]+)\s([asc|desc]+)|[a-z0-9._]+)/i

    def self.parse(raw)
      split(raw, /,/) do |set, part|
        m = part.match(REGEXP)
        return set unless m
        set << [(m[2].nil? ? m[1] : m[2]), (m[3].nil? ? 'asc' : m[3].downcase)]
      end
    end

    def self.encode(set, quote_proc = ->(f) { f })
      set.map { |a| "#{column(a[0], quote_proc)} #{a[1].upcase}" }.join(', ')
    end

    def self.column(parts, quote_proc)
      parts.split('.').map { |frag| quote_proc.call(frag) }.join('.')
    end
    private_class_method :column
  end
end

if defined?(::Rails::Railtie)
  require 'sorted/railtie'
end

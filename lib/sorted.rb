module Sorted
  class Set
    include Enumerable
    include Comparable

    def initialize(set = [])
      @set = set
    end

    def each(&block)
      @set.each(&block)
    end

    ##
    # Gets the keys from the array pairs
    #
    #   set = [["email", "name"], ["desc", "desc"]]
    #   set.transpose #=> [["email", "name"], ["desc", "desc"]]
    #   set.transpose.first #=> ["email", "name"]

    def keys
      @set.transpose.first || []
    end

    ##
    # Returns a resulting set with specific keys flipped
    #
    #   a = Sorted::Set.new([['email', 'asc'], ['name', 'asc']])
    #   b = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    #   s = a.direction_intersect(b)
    #   s.to_a #=> [['email', 'desc'], ['phone', 'asc'], ['name', 'asc']]

    def direction_intersect(other)
      self.class.new.tap do |memo|
        unless other.keys.empty?
          a(memo, other)
          b(memo, other)
        end
        c(memo)
        d(memo, other)
      end
    end

    def -(other)
      self.class.new.tap do |memo|
        each do |a|
          b = other.assoc(a.first)
          next if b
          memo << a
        end
      end
    end

    def +(other)
      self.class.new(@set + other.to_a)
    end

    def <<(a)
      self.class.new(@set << a)
    end

    def <=>(other)
      @set <=> other.to_a
    end

    def uniq
      self.class.new(@set.uniq)
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

    private

    # If the order of keys match upto the size of the set then flip them
    def a(memo, other)
      if keys == other.keys.take(keys.size)
        keys.each do |order|
          if other.keys.include?(order)
            memo << [order, flip_direction(other.assoc(order).last)]
          end
        end
      else
        keys.each do |order|
          if other.keys.include?(order)
            memo << other.assoc(order)
          end
        end
      end
    end

    # Add items from other that are common and not already added
    def b(memo, other)
      other.keys.each do |sort|
        if keys.include?(sort) && !memo.keys.include?(sort)
          memo << other.assoc(sort)
        end
      end
    end

    # Add items not in memo
    def c(memo)
      each do |order|
        unless memo.keys.include?(order[0])
          memo << order
        end
      end
    end

    # Add items from other not in memo
    def d(memo, other)
      other.each do |sort|
        unless memo.keys.include?(sort[0])
          memo << sort
        end
      end
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

    def parse_match(m)
      [(m[2].nil? ? m[1] : m[2]), (m[3].nil? ? 'asc' : m[3].downcase)]
    end
  end

  class URIQuery
    extend Parse

    REGEXP = /(([a-z0-9._]+)_([asc|desc]+)|[a-z0-9._]+)/i

    def self.parse(raw)
      split(raw, /!/) do |set, part|
        m = part.match(REGEXP)
        next unless m
        set << parse_match(m)
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
        next unless m
        set << parse_match(m)
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

  class JSONQuery
    extend Parse

    JSON_TO_SORTED = { 1 => 'asc', -1 => 'desc' }
    SORTED_TO_JSON = { 'asc' => 1, 'desc' => -1 }

    def self.parse(raw)
      Set.new(raw.map { |key, val| [key, JSON_TO_SORTED[val]] })
    end

    def self.encode(set)
      set.inject({}) { |a, e| a.merge(Hash[e[0], SORTED_TO_JSON[e[1]]]) }
    end
  end

  ##
  # Parses an array of decoded query params
  #
  # This parser/encoder uses an already decoded array of sort strings parsed by
  # a URI library.
  #
  # Parsing:
  #
  #   params = ['phone_desc', 'name_asc']
  #   set = Sorted::ParamsQuery.parse(params)
  #   set.to_a #=> [['phone', 'desc'], ['name', asc']]
  #
  # Encoding:
  #
  #   Sorted::ParamsQuery.encode(set) #=> ['phone_desc', 'name_asc']

  class ParamsQuery
    extend Parse

    REGEXP = /(([a-z0-9._]+)_([asc|desc]+)|[a-z0-9._]+)/i

    def self.parse(params)
      params.inject(Set.new) do |set, part|
        m = part.match(REGEXP)
        next unless m
        set << parse_match(m)
      end
    end

    def self.encode(set)
      set.map { |a| a.join('_') }
    end
  end
end

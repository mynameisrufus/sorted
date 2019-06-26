require 'sorted/set'
require 'sorted/parse'

module Sorted
  class SQLQuery
    extend Parse

    REGEXP = %r{
      (([a-z0-9._]+)\s([asc|desc]+)\s?(nulls\s[first|last]+)?|
      ([a-z0-9._]+)\s(nulls\s[first|last]+)|
      ([a-z0-9._]+))
    }xi

    def self.parse(raw)
      split(raw, /,/) do |set, part|
        m = part.match(REGEXP)
        next unless m
        set << parse_match(m)
      end
    end

    def self.encode(set, quote_proc = ->(f) { f })
      set.map do |a|
        encoded = "#{column(a[0], quote_proc)}"

        if sort_has_direction?(a)
          encoded += " #{a[1].upcase}"
          encoded += encode_nulls(a[2]) unless a[2].nil?
        else
          encoded += encode_nulls(a[1]) unless a[1].nil?
        end

        encoded
      end.join(', ')
    end

    def self.sort_has_direction?(raw)
      raw[1].match(/ASC|DESC/i) unless raw[1].nil?
    end
    private_class_method :sort_has_direction?

    def self.encode_nulls(raw_nulls)
      " #{raw_nulls.upcase.tr('_', ' ')}"
    end
    private_class_method :encode_nulls

    def self.column(parts, quote_proc)
      parts.split('.').map { |frag| quote_proc.call(frag) }.join('.')
    end
    private_class_method :column
  end
end

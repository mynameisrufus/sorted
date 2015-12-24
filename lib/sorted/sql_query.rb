require 'sorted/set'
require 'sorted/parse'

module Sorted
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
end

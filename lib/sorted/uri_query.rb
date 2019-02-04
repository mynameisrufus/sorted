require 'sorted/set'
require 'sorted/parse'

module Sorted
  class URIQuery
    extend Parse

    REGEXP = %r{
      (([a-z0-9._]+)_([asc|desc]+)_?(nulls_first|nulls_last)?|
      ([a-z0-9._]+)_(nulls_first|nulls_last))
    }xi

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
end

module Sorted
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
end

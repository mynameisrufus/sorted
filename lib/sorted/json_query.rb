module Sorted
  class JSONQuery
    JSON_TO_SORTED = { 1 => 'asc', -1 => 'desc' }
    SORTED_TO_JSON = { 'asc' => 1, 'desc' => -1 }

    def self.parse(raw)
      Set.new(raw.map { |key, val| [key, JSON_TO_SORTED[val]] })
    end

    def self.encode(set)
      set.inject({}) { |a, e| a.merge(Hash[e[0], SORTED_TO_JSON[e[1]]]) }
    end
  end
end

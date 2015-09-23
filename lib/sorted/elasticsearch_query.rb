require 'sorted/set'

module Sorted
  ##
  # Parses an Elasticsearch type set of order
  #
  # Parsing:
  #
  #   params = [{ 'email' => {'order' => 'desc'}}]
  #   set = Sorted::ElasticsearchQuery.parse(params)
  #   set.to_a #=> [['email', 'desc']]
  #
  # Encoding:
  #
  #   Sorted::ParamsQuery.encode(set) #=> [{ 'email' => {'order' => 'desc'}}]
  #

  class ElasticsearchQuery
    def self.parse(raw)
      Set.new(raw.each_with_object([]) { |hash, a| a << [hash.first.first, hash.first.last['order']] })
    end

    def self.encode(set)
      set.to_a.each_with_object([]) { |f, a| a << { f.first => { 'order' => f.last } } }
    end
  end
end

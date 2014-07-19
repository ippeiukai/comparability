# coding: utf-8

require 'forwardable'

module Comparability
  module Comparators
    class ComparatorChain < Comparator
      extend Forwardable
      include Enumerable

      def initialize(comparators)
        raise ArgumentError unless comparators.size > 0
        raise ArgumentError unless comparators.all? { |c| c.is_a?(Comparator) }
        @comparators = comparators.freeze
      end

      attr_reader :comparators
      delegate :each => :comparators

      def compare(me, other)
        inject(0) do |zero, comparator|
          result = comparator.compare(me, other)
          if result.nil?
            # the comparator failed
            return nil
          elsif result.nonzero?
            # we have the conclusion
            return result
          else
            # a tie
            next 0
          end
        end
      end

    end
  end
end
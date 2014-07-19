# coding: utf-8

module Comparability
  module Comparators
    class WrapperComparator < Comparator

      class << self
        alias_method :wrap, :new
      end

      def initialize(comparator)
        raise ArgumentError unless comparator.is_a?(Comparator)
        @wrapped = comparator
      end

      private

      attr_reader :wrapped

      def wrapped_compare(me, other)
        wrapped.compare(me, other)
      end

    end
  end
end
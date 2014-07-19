# coding: utf-8

require_relative 'wrapper_comparator'

module Comparability
  module Comparators
    class ReverseWrapperComparator < WrapperComparator

      def compare(me, other)
        reverse(wrapped_compare(me, other))
      end

      private

      def reverse(comparison_result)
        if comparison_result.nil? || comparison_result.zero?
          comparison_result
        else
          -comparison_result
        end
      end

    end
  end
end
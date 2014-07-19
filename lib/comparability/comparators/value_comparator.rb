# coding: utf-8

require_relative 'nil_comparator'

module Comparability
  module Comparators
    class ValueComparator < Comparator

      def compare(me, other)
        me_value = extract_value(me)
        other_value = extract_other_value(me, other)

        if nil_value_priority
          nil_result = NilComparator.with_nil_priority(nil_value_priority).compare(me_value, other_value)
          return nil_result if nil_result && nil_result.nonzero?
        end

        me_value <=> other_value
      end

      def nil_value_priority=(priority)
        raise ArgumentError unless [nil, :first, :last].include?(priority)
        @nil_value_priority = priority
      end

      attr_reader :nil_value_priority

      private

      def extract_value(me)
        raise 'abstract'
      end

      def extract_other_value(me, obj)
        extract_value(obj)
      end

    end
  end
end
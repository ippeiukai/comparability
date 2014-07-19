# coding: utf-8

require_relative 'value_comparator'

module Comparability
  module Comparators
    class ValueExtractorComparator < ValueComparator

      def initialize(value_extractor)
        raise ArgumentError unless value_extractor.is_a?(Proc) && value_extractor.arity == 1
        @value_extractor = value_extractor
      end

      private

      attr_reader :value_extractor

      def extract_value(obj)
        value_extractor.(obj)
      end

    end
  end
end
# coding: utf-8

module Comparability
  module Comparators
    class ProcComparator < Comparator

      def initialize(comparison)
        raise ArgumentError unless comparison.is_a?(Proc) && comparison.arity == 2
        self.singleton_class.send(:define_method, :compare, &comparison)
      end

    end
  end
end
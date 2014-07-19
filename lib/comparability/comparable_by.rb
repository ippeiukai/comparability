# coding: utf-8

module Comparability
  module ComparableBy

    private

    # @!visibility public
    # Declares the comparison for this class.
    # This defines <=> instance method and includes Comparable module.
    def comparable_by(*args)
      raise ArgumentError if args.empty?
      comparator = Comparator.chain(*args)
      const_set(:COMPARATOR, comparator)
      define_method(:<=>) { |other| self.class::COMPARATOR.compare(self, other) }
      include Comparable
    end

  end
end
# coding: utf-8


module Comparability
  module Comparators
    module FactoryMethods

      def create(comparison = nil, options = {}, &block)
        comparison ||= block
        comparator =
          case comparison
          when Symbol
            create_from_symbol(comparison)
          when Proc
            create_from_proc(comparison)
          when ->(_) { _.respond_to?(:to_proc) }
            create_from_proc(comparison.to_proc)
          else
            raise ArgumentError, 'invalid comparison'
          end
        apply_options(comparator, options)
      end

      # @param comparisons [Array]
      #   each comparison should be either Comparison instance or argument(s) accepted by #create
      def chain(*comparisons)
        comparators = comparisons.map do |comparison_or_comparator|
          case comparison_or_comparator
          when Comparator
            comparison_or_comparator
          else
            create(*comparison_or_comparator)
          end
        end
        ComparatorChain.new(comparators)
      end
      alias_method :[], :chain

      # @param priority [Symbol] :first or :last
      def prioritize_nil(priority)
        NilComparator.with_nil_priority(priority)
      end

      # @option options [true] :reverse
      def natural_order(options = {})
        @_natural_order ||= Comparator.new
        if options[:reverse]
          @_reverse_natural_order ||= reverse(@_natural_order)
        else
          @_natural_order
        end
      end

      # @param comparator [Comparator]
      def reverse(comparator)
        ReverseWrapperComparator.wrap(comparator)
      end

      private

      def create_from_symbol(attr)
        AttributeValueComparator.new(attr)
      end

      def create_from_proc(proc)
        case proc.arity
        when 1
          ValueExtractorComparator.new(proc)
        when 2
          ProcComparator.new(proc)
        else
          raise ArgumentError, 'invalid comparison'
        end
      end

      def apply_options(comparator, options)
        nil_value_priority = options.fetch(:nil, nil)
        reversing = options.fetch(:reverse, false)

        if nil_value_priority
          raise ArgumentError unless comparator.respond_to?(:nil_value_priority=)
          if reversing
            # value comparison should be reversed, but not the nil priority
            case nil_value_priority
            when :first
              nil_value_priority = :last
            when :last
              nil_value_priority = :first
            end
          end
          comparator.nil_value_priority = nil_value_priority
        end

        if reversing
          comparator = reverse(comparator)
        end

        comparator
      end

    end
  end
end
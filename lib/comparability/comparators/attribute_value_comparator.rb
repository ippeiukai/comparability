# coding: utf-8

require_relative 'value_comparator'

module Comparability
  module Comparators
    class AttributeValueComparator < ValueComparator

      def initialize(attribute)
        attribute = attribute.to_s.freeze unless attribute.is_a?(Symbol)
        @attribute = attribute
      end

      attr_reader :attribute

      private

      def extract_value(me)
        me.send(attribute)
      end

      def extract_other_value(me, _other_)
        if instance_evaluable_attribute?
          # me can access the protected attribute of the other
          me.instance_eval("_other_.#{attribute}()")
        else
          _other_.public_send(attribute)
        end
      end

      INSTANCE_EVALUABLE_METHOD_NAME = /\A([_a-zA-Z][_a-zA-Z0-9]*[!?]?)|([!~+-]@)\Z/
      def instance_evaluable_attribute?
        INSTANCE_EVALUABLE_METHOD_NAME =~ attribute
      end

    end
  end
end
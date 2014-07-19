# coding: utf-8

require 'singleton'

module Comparability
  module Comparators
    module NilComparator

      class << self

        def with_nil_priority(priority)
          raise ArgumentError unless %[first last].include?(priority.to_s)
          public_send("nil_#{priority}")
        end

        def nil_first
          @_nil_first ||= ReverseWrapperComparator.wrap(NilLastComparator.instance)
        end

        def nil_last
          NilLastComparator.instance
        end

      end

      class NilLastComparator < Comparator
        include Singleton

        def compare(me, other)
          if me.nil? && other.nil?
            0
          elsif me.nil?
            1
          elsif other.nil?
            -1
          else
            0
          end
        end

      end

    end
  end
end
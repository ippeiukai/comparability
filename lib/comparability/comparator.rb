# coding: utf-8

module Comparability
  class Comparator
    # @!parse extend Comparability::Comparators::FactoryMethods

    def compare(me, other)
      me <=> other
    end

    def to_proc
      @_to_proc ||= method(:compare).to_proc
    end

  end
end

# require files in ./comparators
File.dirname(File.expand_path(__FILE__)).tap do |this_dirname|
  Dir[File.join(this_dirname, 'comparators', '**', '*.rb')].each do |file|
    name = file.gsub(%r|^#{Regexp.escape(this_dirname)}/(.*)#{Regexp.escape('.rb')}|, '\1')
    require_relative name
  end
end

Comparability::Comparator.extend(Comparability::Comparators::FactoryMethods)

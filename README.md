# Comparability

Provides Comparator and declarative definition of comparison operator.

## Installation

Add this line to your application's Gemfile:

    gem 'comparability'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install comparability

## Usage

### ComparableBy (Declarative definition of comparison operator)

You can declaratively define your class's comparison with ``comparable_by`` method. 
To use, you need to extend your class with ``ComparableBy`` module. 

    require 'comparability'
    
    class MyClass < Struct.new(:a, :b, :c, :d)
      extend ComparableBy
      
      attr_reader :a, :b, :c, :d, :e
            
      comparable_by :a,                              # order of a
                    [:b, reverse: true],             # reverse order of a
                    [:c, nil: :first],               # order of c, ordered first if c is nil  
                    [:d, reverse: true, nil: :last]  # reverse order of d, ordered last if d is nil  
                    ->(_){ _.e.upcase },             # order of e, case-insensitive    
    end  
      
Call of ``comparable_by`` defines ``<=>`` instance method, and includes ``Comparable`` module.           
Each parameter to ``comparable_by`` should be either an instance of ``Comparator`` or arguments to ``Comparator.create``
in order of precedence.             
           
### Comparator

Some pre-defined comparisons are accessible with special methods.
Other variations are created with ``Comparator.create``.

#### natural order

The most simple ``Comparator`` which just evokes the comparison (spaceship) operator.
 
    Comparator.natural_order                 # essentially compare(a,b) is defined as a <=> b
    Comparator.natural_order(reverse: true)  # b <=> a instead
    
#### nil priority
    
This special ``Comparator`` orders only by whether object is nil or not.
     
    Comparator.prioritize_nil(:first)  # nil is smaller
    Comparator.prioritize_nil(:last)   # nil is bigger 

#### by attribute value

If you specify a symbol to ``Comparator.create``,
the comparator will compare objects by the results of the specified method. 
  
    Comparator.create(:size)                 # compares by size (prioritise smaller)
    Comparator.create(:size, reverse: true)  # compares by size (prioritise bigger) 
    
You can use ``:nil`` option to specify the priority of nil value.     
    
    Comparator.create(:priority, nil: :last)                 # compares by priority (prioritise smaller, last if nil)
    Comparator.create(:priority, reverse: true, nil: :last)  # compares by priority (prioritise bigger, last if nil) 
    
The attribute method can be public or protected, but not private.    
    
#### by value extractor        

If you specify a proc with arity 1 to ``Comparator.create``,
the comparator will compare objects by the results of the specified proc yielding each object. 

You can also pass the comparison as block.
                                                                                        
    Comparator.create { |str| str.length }   # compares by length (prioritise shorter)  
    Comparator.create { |str| -str.length }  # compares by length (prioritise longer)
            
#### with proc
                                                                
If you specify a proc with arity 2 to ``Comparator.create``,
it creates a comparator defined by the specified proc.
 
You can also pass the comparison as block.
 
    Comparator.create do |obj1, obj2| 
      # ... your comparison here ... 
    end
               
#### chaining

You can chain comparators with ``Comparator.chain`` or its alias ``Comparator.[]``.

    Comparator[comparator1, comparator2]  # compares with comparator1, then tie-breaks with comparator2

#### reversing

You can reverse existing comparators with ``Comparator.reverse``.

    Comparator.reverse(comparator)  # reverses the order

#### ``Enumerable#sort`` usage

``Comparator#to_proc`` returns a ``Proc`` compatible with ``Enumerable#sort``.
You can use the ampersand shorthand to convert a comparator and pass as block. 

    comparator = Comparator[Comparator.prioritize_nil(:last), 
                            Comparator.natural_order(reverse: true)] 
    [nil,1,2,3,4].sort(&comparator)  # => [4, 3, 2, 1, nil] 

## Contributing

1. Fork it ( http://github.com/ippeiukai/comparability/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

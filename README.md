# Cascading Configuration #

http://rubygems.org/gems/cascading_configuration

# Summary #

Provides inheritable values across Ruby inheritance hierarchy or across arbitrary declared inheritance relations.

# Description #

Inheritable Objects and Downward-Compositing Hashes and Arrays; Downward-Transforming Values coming soon.

# Install #

* sudo gem install cascading_configuration

# Usage #

Since CascadingConfiguration produces configurations for both singletons and instances, include or extend of a CascadingConfiguration module (for instance CascadingConfiguration::Setting) also causes the including instance to be extended by module::ClassInstance (ie CascadingConfiguration::Setting::ClassInstance).

The result is that extending will enable only the singleton, whereas including will enable both singleton and instances.

Each module supports the same pattern for naming methods it provides.

The module has a name, which is used in each of the method types:

```ruby
:value                  # =>  :attr_value
:setting                # =>  :attr_setting
:hash                   # =>  :attr_hash
:array                  # =>  :attr_array
:unique_array           # =>  :attr_unique_array
:sorted_array           # =>  :attr_sorted_array
:sorted_unique_array    # =>  :attr_sorted_unique_array
```

For backwards compatibility, these methods are also available:

```ruby
:attr_configuration
:attr_configuration_hash
:attr_configuration_array
:attr_configuration_unique_array
:attr_configuration_sorted_array
:attr_configuration_sorted_unique_array
```

## Base Method Naming Pattern ##

There are 5 types of base methods:

### :attr\_[module\_name] ###

Cascading methods, which will affect instances according to include/extend pattern used.

### :attr\_module\_[module\_name] and attr\_class\_[module\_name] ###

Cascading module/class methods, which will affect all module singletons according to include/extend pattern used.

### :attr\_instance\_[module\_name] ###

Cascading instance methods, which will affect instances of including modules according to include/extend pattern used.

### :attr\_local\_[module\_name] ###

Non-cascading methods that will affect the instance declared on as well as instances of that instance, if applicable.

### :attr\_object\_[module\_name] ###

Non-cascading methods that will affect only the instance declared on.

## Inheritable Objects ##

Inheritable Objects are values received from an ancestor:

```ruby
module ModuleA
  include CascadingConfiguration::Setting
  attr_setting  :some_setting
  self.some_setting = :some_value
end

class ClassA
  include ModuleA
  self.some_setting = :some_other_value
end

class ClassB < ClassA
  some_setting == :some_other_value
  self.some_setting = :another_value
end

class ClassC < ClassB
  some_setting == :another_value
end
```

Simply put, the instance asked for the value will look up its ancestor chain until it finds an explicitly assigned value, which it returns.

This is provided by:

* CascadingConfiguration::Setting

## Downward-Compositing Hashes and Arrays ##

Whether Hashes or Arrays, the idea is the same. We call the Compositing Objects. They all work the same way (automatically):

1. The compositing object is initialized with a reference to the configuration instance it is attached to.
2. The compositing object is initialized (separately) for its immediate parent object.
3. Whenever an update occurs, the compositing object updates its registered child object with the update.

This way the lower objects are kept in sync with parent elements. Overriding hooked methods (provided by Array::Hooked from the array-hooked gem) provides a great deal of flexible functionality, permitting elements to be transformed as they are passed down the ancestor hierarchy.

Right now there are 5 types of Compositing Objects:

* CascadingConfiguration::Hash
* CascadingConfiguration::Array
* CascadingConfiguration::Array::Unique
* CascadingConfiguration::Array::Sorted
* CascadingConfiguration::Array::Sorted::Unique

All work the same with the exception of differing compositing object types. All declarations of compositing object configurations also accept extension modules and/or a block that will be used to create an extension module. Extension modules will be used to extend the compositing object; extension modules automatically cascade along the ancestor hierarchy for a given configuration. 

```ruby
module ModuleA
  include CascadingConfiguration::Array
  attr_array  :some_array
  some_array == [ ]
  some_array.push( :some_value )
  some_array == [ :some_value ]
end

class ClassA
  include ModuleA
  some_array == [ :some_value ]
end

class ClassB < ClassA
  some_array == [ :some_value ]
  some_array.push( :another_value )
  some_array == [ :some_value, :another_value ]
end

class ClassC < ClassB
  some_setting == :another_value
  some_array.delete( :some_value )
  some_array == [ :another_value ]
end
```

The end result:

```ruby
ModuleA.some_array == [ :some_value ]

ClassA.some_array == [ :some_value ]

ClassB.some_array == [ :some_value, :another_value ]

ClassA.some_array == [ :another_value ]
```

## Downward-Transforming Values ##

Each time a child is registered, Downward-Transforming Values are processed via a block to produce the new value that the inheriting instance will receive. 

```ruby
module ModuleA
  include CascadingConfiguration::Value
  attr_value  :cascading_value do |parent_value, parent_instance|
    # return child value - self is child
    child_value = parent_value + 1 # assume parent_value is a number
  end
  self.cascading_value = 1
end

module ModuleB
  include ModuleA
  # cascading_value == 2
end
```

## Configuration Modules ##

Including or extending CascadingConfiguration includes or extends all of its configuration modules:

* CascadingConfiguration::Value
* CascadingConfiguration::Setting
* CascadingConfiguration::Hash
* CascadingConfiguration::Array
* CascadingConfiguration::Array::Unique
* CascadingConfiguration::Array::Sorted
* CascadingConfiguration::Array::Sorted::Unique

These modules can also be used individually in the same way (simply include or extend).

# License #

  (The MIT License)

  Copyright (c) Asher

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

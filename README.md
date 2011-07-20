# Cascading Configuration #

http://rubygems.org/gems/cascading-configuration

# Description #

Adds methods for cascading configurations.

# Summary #

Cascading configuration methods for single-object settings, arrays, hashes.

The cascading aspect of each works the same, returning the appropriate lowest accumulated value. Configuration inheritance can cascade through modules, classes, and to instances.

This means that we can create configuration modules, optionally setting configuration defaults, and include those configuration modules in other modules or classes.

# Install #

* sudo gem install cascading-configuration

# Usage #

Including the module will enable support for singleton and for instances.

```ruby
module AnyModuleOrClass
  include CascadingConfiguration
end
```

Extending the module will enable support for singleton only.

```ruby
module AnyModuleOrClass
  extend CascadingConfiguration
end
```

Including or extending CascadingConfiguration includes or extends:

* CascadingConfiguration::Setting
* CascadingConfiguration::Array
* CascadingConfiguration::Hash

Accordingly, each module can also be used independently. The first package included or extended with also include/extend the common support package:

* CascadingConfiguration::Variable

## :attr_configuration ##

:attr_configuration provides inheritable single-object configurations that cascades downward. The value lowest in the ancestor hierarchy will be returned.

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Setting

  attr_configuration :some_setting

  some_setting # => nil

  # note: if we don't specify the receiver here (self) assignment creates local variable instead
  self.some_setting = :some_value

  some_setting # => :some_value

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  some_setting # => :some_value

  self.some_setting = :some_other_value

  some_setting # => :some_other_value

  SomeModule.some_setting # => :some_value

end
```

And it cascades to instances:

```ruby
instance = SomeClass.new

instance.some_setting.should == :some_value

instance.some_setting = :another_value

instance.some_setting.should == :another_value
```

### :attr_module_configuration, :attr_class_configuration ###

:attr_class_configuration works like :attr_configuration but does not cascade to instances.

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Setting

  attr_class_configuration :some_setting

  some_setting # => nil

  self.some_setting = :some_value

  some_setting # => :some_value

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  some_setting # => :some_value

  self.some_setting = :some_other_value

  some_setting # => :some_other_value

  SomeModule.some_setting # => :some_value

end
```

And it does not cascade to instances:

```ruby
instance = SomeClass.new

instance.respond_to?( :some_setting ).should == false
```

### :attr_local_configuration ###

:attr_local_configuration works like :attr_configuration but does not cascade. This is primarily useful for creating local configurations maintained in parallel with cascading configurations (for instance, with the same variable prefixes), for overriding the local configuration method, and for hiding the configuration variable (coming soon).

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Setting

  attr_local_configuration :some_setting

  some_setting # => nil

  self.some_setting = :some_value

  some_setting # => :some_value

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  respond_to?( :some_setting ).should == false

end
```

## :attr_configuration_array ##

:attr_configuration_array provides inheritable array configurations that cascade downward. A composite sorted and unique array will be returned (merging downward from most distant ancestor to self). 

An internal cache is kept, and any configuration updates that occur to higher-level ancestors cascade immediately downward. 

The array maintained by :attr_configuration_array is kept ordered and unique.

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Array

  attr_array_configuration :some_array_setting

  some_array_setting # => nil

  some_array_setting.push( :some_value )

  some_array_setting # => [ :some_value ]

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  some_array_setting # => [ :some_value ]

  self.some_array_setting = [ :some_other_value ]

  some_array_setting # => [ :some_other_value ]

  some_array_setting.push( :another_value ) # => [ :another_value, :some_other_value ]

  SomeModule.some_array_setting # => [ :some_value ]

end
```

And it cascades to instances:

```ruby
instance = SomeClass.new

instance.some_array_setting.should == [ :another_value, :some_other_value ]

instance.some_array_setting.delete( :some_other_value )

instance.some_array_setting.should == [ :another_value ]
```

### :attr_module_configuration_array, :attr_class_configuration_array ###

:attr_class_configuration_array works like :attr_configuration_array but does not cascade to instances.

```ruby
module SomeModule

  include CascadingConfiguration::Array

  attr_array_configuration :some_array_setting

  some_array_setting # => nil

  some_array_setting.push( :some_value )

  some_array_setting # => [ :some_value ]

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  some_array_setting # => [ :some_value ]

  self.some_array_setting = [ :some_other_value ]

  some_array_setting # => [ :some_other_value ]

  some_array_setting.push( :another_value ) # => [ :another_value, :some_other_value ]

  SomeModule.some_array_setting # => [ :some_value ]

end
```

And it does not cascade to instances:

```ruby
instance = SomeClass.new

instance.respond_to?( :some_array_setting ).should == false
```

### :attr_local_configuration_array ###

:attr_local_configuration_array works like :attr_configuration_array but does not cascade. This is primarily useful for creating local configurations maintained in parallel with cascading configurations (for instance, with the same variable prefixes), for overriding the local configuration method, and for hiding the configuration variable (coming soon).

```ruby
module SomeModule

  include CascadingConfiguration::Array

  attr_array_configuration :some_array_setting

  some_array_setting # => nil

  some_array_setting.push( :some_value )

  some_array_setting # => [ :some_value ]

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  respond_to?( :some_array_setting ).should == false

end
```

## :attr_configuration_hash ##

:attr_configuration_array provides inheritable hash configurations that cascade downward. A composite hash will be returned (merging downward from most distant ancestor to self). 

An internal cache is kept, and any configuration updates that occur to higher-level ancestors cascade immediately downward.

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Hash

  attr_configuration_hash :some_hash_setting

  some_hash_setting # => nil

  some_hash_setting[ :some_setting ] = :some_value

  some_hash_setting[ :some_setting ] # => :some_value

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  some_hash_setting[ :some_setting ] # => :some_value

  self.some_hash_setting.replace( :some_other_setting => :some_other_value )

  some_hash_setting # => { :some_other_setting => :some_other_value }

end
```

And it cascades to instances:

```ruby
instance = SomeClass.new

instance.some_hash_setting.should == { :some_other_setting => :some_other_value }

instance.some_hash_setting.delete( :some_other_setting )

instance.some_hash_setting.should == {}
```

### :attr_module_configuration_hash, :attr_class_configuration_hash ###

:attr_class_configuration_hash works like :attr_configuration_hash but does not cascade to instances.

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Hash

  attr_class_configuration_hash :some_hash_setting

  some_hash_setting # => nil

  some_hash_setting[ :some_setting ] = :some_value

  some_hash_setting[ :some_setting ] # => :some_value

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  some_hash_setting[ :some_setting ] # => :some_value

  self.some_hash_setting.replace( :some_other_setting => :some_other_value )

  some_hash_setting # => { :some_other_setting => :some_other_value }

end
```

And it does not cascade to instances:

```ruby
instance = SomeClass.new

instance.respond_to?( :some_hash_setting ).should == false
```

### :attr_local_configuration_hash ###

:attr_local_configuration_hash works like :attr_configuration_hash but does not cascade. This is primarily useful for creating local configurations maintained in parallel with cascading configurations (for instance, with the same variable prefixes), for overriding the local configuration method, and for hiding the configuration variable (coming soon).

Define initial configuration in a module or class:

```ruby
module SomeModule

  include CascadingConfiguration::Hash

  attr_class_configuration_hash :some_hash_setting

  some_hash_setting # => nil

  some_hash_setting[ :some_setting ] = :some_value

  some_hash_setting[ :some_setting ] # => :some_value

end
```

Include initial module in a module or class:

```ruby
class SomeClass

  include SomeModule

  respond_to?( :some_hash_setting ).should == false

end
```

## Additional Functionality ##

Cascading-configuration also provides several other convenience functions. 

### Method Redefinition ###

Any declared configuration is defined in order to support locally redefining the method and accessing the original by calling super.

```ruby
module SomeModule

  include CascadingConfiguration

  attr_configuration :some_array_setting

  def some_array_setting=( value )
    puts 'Replacing configuration array!'
    super
  end

end
```

# License #

  (The MIT License)

  Copyright (c) 2011 Asher

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
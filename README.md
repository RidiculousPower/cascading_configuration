== Cascading Configuration

http://rubygems.org/gems/cascading-configuration

== DESCRIPTION:

Adds methods for cascading configurations.

== SUMMARY:

Cascading configuration methods for single settings, arrays, hashes.

# :attr_configuration #

:attr_configuration provides inheritable configuration that cascades downward. 

Configuration inheritance can cascade through modules, classes, and instances.

:attr_configuration defines a single attribute accessor that searches upward for the first ancestor defining the configuration. 

# :attr_configuration_array #

:attr_configuration_array provides inheritable configuration that cascades downward. 

Configuration inheritance can cascade through modules, classes, and instances.

:attr_configuration_array defines a single attribute accessor that composes the set of configuration values appropriate to the ancestor level being queried (merging downward from most distant ancestor to self). An internal cache is kept, and any configuration updates that occur to higher-level ancestors cascade immediately downward.

The array maintained by :attr_configuration_array is kept ordered and unique.

# :attr_configuration_hash #

:attr_configuration_hash provides inheritable configuration that cascades downward. 

Configuration inheritance can cascade through modules, classes, and instances.

:attr_configuration_hash defines a single attribute accessor that composes the set of configuration values appropriate to the ancestor level being queried (merging downward from most distant ancestor to self). An internal cache is kept, and any configuration updates that occur to higher-level ancestors cascade immediately downward.

# Install #

* sudo gem install cascading-configuration

# Usage #

See supporting package README files for examples in each case:

* attr_configuration
* attr_configuration_array
* attr_configuration_hash

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
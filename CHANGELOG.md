
## 6/18/2012 ##

Moved cascading_configuration-ancestors to a new independent gem: parallel-ancestry.

Now with Less Magic™ and more Tasty Sandwiches™!

Condensed cascading_configuration-variable, cascading_configuration-methods, cascading_configuration-definition, cascading_configuration-inheritance, cascading_configuration-module, cascading_configuration-setting, cascading_configuration-array, cascading_configuration-array-unique, cascading_configuration-array-sorted, cascading_configuration-sorted-unique, cascading_configuration-hash into a single gem with core support.

Adding new modules is now incredibly easy, and all the old spaghetti internal code is gone.

## 6/19/2012 ##

Fix for multiple arguments.

README updates.

Removed Methods module and submodules - methods moved into InstanceController directly.

Fixed parameters for alias methods on InstanceController.

Changed inheritance for extends to behave like module inheritance. Now extending an instance with a CCM-enabled module will cause instance methods to be appended to extended instances eigenclass chain; singleton methods will not cascade for extend.

Fixed Class instance configuration lookups.

Fixed for FalseClass.

Fixed for Object.

## 6/24/2012 ##

Added Instance and Singleton support module subclasses - fixes case where singleton support is created after extending with an instance with singleton support, causing the extending instance's singleton support to be both improperly included and below the instance, stomping any of its methods.

Added :initialize_configuration to CascadingConfiguration::Module; subclasses override to perform object initialization post-creation. This is so that objects are initialized only after all objects have been instantiated.

## 6/27/2012 ##

Renamed project from cascading-configuration to cascading_configuration to match Rubygems guidelines for gem naming.
Ensured configurations don't re-register parents that are higher in the ancestor chain than the ones already registered.

## 7/15/2012 ##

Added support in extension modules for aliasing methods that will exist in object extended by extension module but does not exist yet in extension module.

## 7/19/2012 ##

Register for parent needs to happen before not after include/extend.

## 10/15/2012 ##

Updated for multiple parents for compositing objects. 
First parent is treated as parent for purpose of extension modules, etc.
Extension modules for other parents must be added manually - functions coming for that but not implemented yet.

## 1/26/2013 ##

Rewrite of internals to add configuration objects.
Removed Core distinction. Internals are now considered public code, although they will still be marked private for documentation purposes, since they are only intended for developers.
Tasty Sandwiches™ taste better!
Also rewrote all specs except the public module specs. Those will have new specs soon.
Added :should_cascade? to configuration instances, resulting in inheritance being defined by configuration instance as well as by method inheritance.
As a result, :attr_class\_... and :attr\_module are no longer the same as :attr\_singleton; singleton will define singleton-only cascading methods, while class will define methods that cascade to a class and module will define methods that cascade to a module.

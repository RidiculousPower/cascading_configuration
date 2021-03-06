
## 6/18/2012 ##

Moved cascading\_configuration-ancestors to a new independent gem: parallel-ancestry.

Now with Less Magic™ and more Tasty Sandwiches™!

Condensed cascading\_configuration-variable, cascading\_configuration-methods, cascading\_configuration-definition, cascading\_configuration-inheritance, cascading\_configuration-module, cascading\_configuration-setting, cascading\_configuration-array, cascading\_configuration-array-unique, cascading\_configuration-array-sorted, cascading\_configuration-sorted-unique, cascading\_configuration-hash into a single gem with core support.

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

Added :initialize\_configuration to CascadingConfiguration::Module; subclasses override to perform object initialization post-creation. This is so that objects are initialized only after all objects have been instantiated.

## 6/27/2012 ##

Renamed project from cascading-configuration to cascading\_configuration to match Rubygems guidelines for gem naming.
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

## 3/4/2013 ##

Added CascadingConfiguration::Value (:attr\_value) for inheriting values that transform as they cascade. 
Added definition of :•configuration\_name to retrieve configuration instance in addition to :configuration\_name and :configuration\_name= to get/set value.

## 3/15/2013 ##

Changed behavior of :object methods and :local\_instance methods so that :local\_instance means current object only and :object means current object and instances descended from current object.

## 8/13/2013 ##

Simplified CCM structure to remove ClassInstance and require extend (include no longer supported).


## 6/18/2012 ##

Moved cascading-configuration-ancestors to a new independent gem: parallel-ancestry.

Now with Less Magic™ and more Tasty Sandwiches™!

Condensed cascading-configuration-variable, cascading-configuration-methods, cascading-configuration-definition, cascading-configuration-inheritance, cascading-configuration-module, cascading-configuration-setting, cascading-configuration-array, cascading-configuration-array-unique, cascading-configuration-array-sorted, cascading-configuration-sorted-unique, cascading-configuration-hash into a single gem with core support.

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

Added :initialize_configuration to CascadingConfiguration::Core::Module; subclasses override to perform object initialization post-creation. This is so that objects are initialized only after all objects have been instantiated.

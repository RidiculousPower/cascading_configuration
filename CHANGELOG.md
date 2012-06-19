
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


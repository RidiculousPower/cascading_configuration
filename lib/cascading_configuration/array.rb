
###
#  CascadingConfiguration::Array allows definition of array attributes that will composite downward through
#  the ancestor chain.
# 
module ::CascadingConfiguration::Array

  ###
  # Cascading array attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_array
  #
  # @overload attr_array( *names )
  #   
  #   @scope 
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String},Module] name The name to be used 
  #    for the declared attribute. If a array is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #    and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ###
  # Cascading array attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_array
  #
  # @overload attr_module_array( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a array is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #    and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ###
  # Cascading array instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_array
  #
  # @overload attr_instance_array( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a array is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #    and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ###
  # Non-cascading array methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_array
  #
  # @overload attr_local_array( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a array is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #    and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ###
  # Non-cascading array methods that will affect only the instance declared on.
  #
  # @method attr_object_array
  #
  # @overload attr_object_array( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a array is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #    and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  array_module = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::
                   CompositingObjects.new( :array, ::Array::Compositing, :default, :configuration_array )
  
  ::CascadingConfiguration::Core.enable( self, array_module )

end
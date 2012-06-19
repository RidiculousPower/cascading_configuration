
###
#  CascadingConfiguration::Setting allows definition of setting attributes that will retrieve
#  the first value defined in an instance looking up the ancestor chain.
# 
module ::CascadingConfiguration::Setting
  
  ###
  # Cascading setting attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_setting
  #
  # @overload attr_setting( *names )
  #   
  #   @scope 
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a hash is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ###
  # Cascading setting attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_setting
  #
  # @overload attr_module_setting( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a hash is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ###
  # Cascading setting instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_setting
  #
  # @overload attr_instance_setting( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a hash is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ###
  # Non-cascading setting methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_setting
  #
  # @overload attr_local_setting( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a hash is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ###
  # Non-cascading setting methods that will affect only the instance declared on.
  #
  # @method attr_object_setting
  #
  # @overload attr_object_setting( *names )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name The name to be used 
  #    for the declared attribute. If a hash is passed, each key will be used as the setting 
  #    name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #
  
  setting_module = ::CascadingConfiguration::Core::Module::InheritingValues.new( :setting, :default, :configuration )
  
  ::CascadingConfiguration::Core.enable( self, setting_module )

end

# -*- encoding : utf-8 -*-

###
#  CascadingConfiguration::Array allows definition of array attributes that will composite downward through
#  the ancestor chain and ensure that member elements remain unique.
# 
::CascadingConfiguration::Array::Unique = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::
                                            CompositingObjects::Array.new( :unique_array, 
                                                                           ::Array::Unique::Compositing, 
                                                                           :configuration_unique_array )
module ::CascadingConfiguration::Array::Unique

  ::CascadingConfiguration.register_configuration_module( self )

  #######################
  #  attr_unique_array  #
  #######################

  ###
  # Cascading array attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_unique_array
  #
  # @overload attr_unique_array( name, ... )
  #   
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a array is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ##############################
  #  attr_module_unique_array  #
  ##############################

  ###
  # Cascading array attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_unique_array
  #
  # @overload attr_module_unique_array( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a array is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ################################
  #  attr_instance_unique_array  #
  ################################

  ###
  # Cascading array instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_unique_array
  #
  # @overload attr_instance_unique_array( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a array is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  #############################
  #  attr_local_unique_array  #
  #############################

  ###
  # Non-cascading array methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_unique_array
  #
  # @overload attr_local_unique_array( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a array is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ##############################
  #  attr_object_unique_array  #
  ##############################

  ###
  # Non-cascading array methods that will affect only the instance declared on.
  #
  # @method attr_object_unique_array
  #
  # @overload attr_object_unique_array( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a array is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

end

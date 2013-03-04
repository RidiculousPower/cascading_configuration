# -*- encoding : utf-8 -*-

###
#  CascadingConfiguration::Array allows definition of array attributes that will composite downward through
#  the ancestor chain.
# 
module ::CascadingConfiguration::Array

  ################
  #  attr_array  #
  ################

  ###
  # Cascading array attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_array
  #
  # @overload attr_array( name, ... )
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
  #          Creates a new Module of type CascadingConfiguration::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  #######################
  #  attr_module_array  #
  #######################

  ###
  # Cascading array attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_array
  #
  # @overload attr_module_array( name, ... )
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
  #          Creates a new Module of type CascadingConfiguration::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  #########################
  #  attr_instance_array  #
  #########################

  ###
  # Cascading array instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_array
  #
  # @overload attr_instance_array( name, ... )
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
  #          Creates a new Module of type CascadingConfiguration::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ######################
  #  attr_local_array  #
  ######################

  ###
  # Non-cascading array methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_array
  #
  # @overload attr_local_array( name, ... )
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
  #          Creates a new Module of type CascadingConfiguration::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  #######################
  #  attr_object_array  #
  #######################

  ###
  # Non-cascading array methods that will affect only the instance declared on.
  #
  # @method attr_object_array
  #
  # @overload attr_object_array( name, ... )
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
  #          Creates a new Module of type CascadingConfiguration::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  array_module = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::
                   CompositingObjects::Array.new( :array, ::Array::Compositing, :configuration_array )
  
  ::CascadingConfiguration.enable_instance_as_cascading_configuration_module( self, array_module )

end

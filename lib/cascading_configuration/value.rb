# -*- encoding : utf-8 -*-

###
#  CascadingConfiguration::Setting allows definition of value attributes that will retrieve
#  the first value defined in an instance looking up the ancestor chain.
# 
module ::CascadingConfiguration::Value
  
  ################
  #  attr_value  #
  ################
  
  ###
  # Cascading value attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_value
  #
  # @overload attr_value( name, ... )
  #   
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the value name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  #######################
  #  attr_module_value  #
  #######################

  ###
  # Cascading value attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_value
  #
  # @overload attr_module_value( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the value name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  #########################
  #  attr_instance_value  #
  #########################

  ###
  # Cascading value instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_value
  #
  # @overload attr_instance_value( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the value name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ######################
  #  attr_local_value  #
  ######################

  ###
  # Non-cascading value methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_value
  #
  # @overload attr_local_value( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the value name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  #######################
  #  attr_object_value  #
  #######################

  ###
  # Non-cascading value methods that will affect only the instance declared on.
  #
  # @method attr_object_value
  #
  # @overload attr_object_value( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the value name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #
  
  value_module = ::CascadingConfiguration::Module::BlockConfigurations::CascadingValues.new( :value )
  
  ::CascadingConfiguration.enable_instance_as_cascading_configuration_module( self, value_module )

end

# -*- encoding : utf-8 -*-

###
#  CascadingConfiguration::Setting allows definition of setting attributes that will retrieve
#  the first value defined in an instance looking up the ancestor chain.
# 
module ::CascadingConfiguration::Setting
  
  ##################
  #  attr_setting  #
  ##################
  
  ###
  # Cascading setting attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_setting
  #
  # @overload attr_setting( name, ... )
  #   
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  #########################
  #  attr_module_setting  #
  #########################

  ###
  # Cascading setting attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_setting
  #
  # @overload attr_module_setting( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ###########################
  #  attr_instance_setting  #
  ###########################

  ###
  # Cascading setting instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_setting
  #
  # @overload attr_instance_setting( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  ########################
  #  attr_local_setting  #
  ########################

  ###
  # Non-cascading setting methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_setting
  #
  # @overload attr_local_setting( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #

  #########################
  #  attr_object_setting  #
  #########################

  ###
  # Non-cascading setting methods that will affect only the instance declared on.
  #
  # @method attr_object_setting
  #
  # @overload attr_object_setting( name, ... )
  #
  #   @param [Symbol,String,Hash{Symbol,String=>Symbol,String}] name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @return self
  #
  
  setting_module = ::CascadingConfiguration::Module::CascadingSettings.new( :setting, :configuration )
  
  ::CascadingConfiguration.enable_instance_as_cascading_configuration_module( self, setting_module )

end

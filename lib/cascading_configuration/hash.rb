
###
#  CascadingConfiguration::Hash allows definition of hash attributes that will composite downward through
#  the ancestor chain.
# 
module ::CascadingConfiguration::Hash

  ###############
  #  attr_hash  #
  ###############

  ###
  # Cascading hash attribute methods, which will affect instances according to include/extend pattern used.
  #
  # @method attr_hash
  #
  # @overload attr_hash( *names )
  #   
  #   @param [ Symbol, String, Hash{ Symbol,String => Symbol,String }, Module ] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ]
  #
  #          Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ######################
  #  attr_module_hash  #
  ######################

  ###
  # Cascading hash attribute module/class methods, which will affect all module singletons 
  #   according to include/extend pattern used.
  #
  # @method attr_module_hash
  #
  # @overload attr_module_hash( *names )
  #
  #   @param [ Symbol, String, Hash{ Symbol,String => Symbol,String } ] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ########################
  #  attr_instance_hash  #
  ########################

  ###
  # Cascading hash instance methods, which will affect instances of including modules according to 
  #   include/extend pattern used.
  #
  # @method attr_instance_hash
  #
  # @overload attr_instance_hash( *names )
  #
  #   @param [ Symbol, String, Hash{ Symbol,String => Symbol,String } ] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  #####################
  #  attr_local_hash  #
  #####################

  ###
  # Non-cascading hash methods that will affect the instance declared on as well as instances of that instance, 
  #   if applicable.
  #
  # @method attr_local_hash
  #
  # @overload attr_local_hash( *names )
  #
  #   @param [ Symbol, String, Hash{ Symbol,String => Symbol,String } ] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  ######################
  #  attr_object_hash  #
  ######################

  ###
  # Non-cascading hash methods that will affect only the instance declared on.
  #
  # @method attr_object_hash
  #
  # @overload attr_object_hash( *names )
  #
  #   @param [ Symbol, String, Hash{ Symbol,String => Symbol,String } ] 
  #
  #          name 
  #
  #          The name to be used for the declared attribute. If a hash is passed, each key will be used as 
  #          the setting name and accessor and each value will be used as the corresponding write accessor.
  #
  #   @yield [ ] 
  #
  #          Creates a new Module of type CascadingConfiguration::Core::InstanceController::ExtensionModule
  #          and runs module_eval( & block ) on instance with provided block.
  #
  #   @return self
  #

  hash_module = ::CascadingConfiguration::Core::Module::ExtendableConfigurations::
                  CompositingObjects.new( :hash, ::Hash::Compositing, :configuration_hash )
  
  ::CascadingConfiguration::Core.enable_instance_as_cascading_configuration_module( self, hash_module )

end


###
# Support for enabling Configuration Modules. 
#   Defined separately so that it can load before modules that depend upon it.
#
module ::CascadingConfiguration

  @configuration_modules = ::Array::Unique.new

  ################################
  #  self.configuration_modules  #
  ################################
  
  def self.configuration_modules
    
    return @configuration_modules
    
  end
  
  ########################################
  #  self.register_configuration_module  #
  ########################################
  
  def self.register_configuration_module( configuration_module )
    
    @configuration_modules.push( configuration_module )
    
    return self
    
  end
  
  ############################################################
  #  self.enable_instance_as_cascading_configuration_module  #
  ############################################################
  
  ###
  # Enable Module instance as a cascading configuration module.
  #
  def self.enable_instance_as_cascading_configuration_module( instance_to_enable, configuration_module_instance )
    
    # Store the configuration module we are enabling in instance at instance::ClassInstance
    instance_to_enable.const_set( :ClassInstance, configuration_module_instance )

    # Enable module instance so that when included it creates instance support
    instance_to_enable.extend( ::CascadingConfiguration::IncludeCreatesInstanceSupport )

    instance_to_enable.extend( ::Module::Cluster )

    instance_to_enable.cluster( :cascading_configuration ).after_include.extend( instance_to_enable::ClassInstance )
    instance_to_enable.cluster( :cascading_configuration ).after_extend.extend( instance_to_enable::ClassInstance )
    
    register_configuration_module( instance_to_enable )
    
    return self
    
  end

end

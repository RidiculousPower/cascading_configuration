
###
# Namespace for all internal CascadingConfiguration code. 
#   Anything in this namespace may change.
#
module ::CascadingConfiguration::Core
  
  ############################################################
  #  self.enable_instance_as_cascading_configuration_module  #
  ############################################################
  
  ###
  # Enable Module instance as a cascading configuration module.
  #
  def self.enable_instance_as_cascading_configuration_module( instance, core_module )
    
    # Store the configuration module we are enabling in instance at instance::ClassInstance
    instance.const_set( :ClassInstance, core_module )

    # Enable module instance so that when included it creates instance support
    instance.extend( ::CascadingConfiguration::Core::IncludeCreatesInstanceSupport )

    instance.extend( ::Module::Cluster )

    instance.cluster( :cascading_configuration ).after_include.extend( instance::ClassInstance )
    instance.cluster( :cascading_configuration ).after_extend.extend( instance::ClassInstance )
    
  end
  
end

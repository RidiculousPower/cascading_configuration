
class ::CascadingConfiguration::Core::InstanceController::SupportModule::InstanceSupportModule < 
      ::CascadingConfiguration::Core::InstanceController::SupportModule

  ######################
  #  is_super_module?  #
  ######################
  
  def is_super_module?( module_instance )

    is_super_module = false
    
    if is_super_module = super
      is_super_module = module_instance.included?( @instance_controller.instance )
    end
    
    return is_super_module
    
  end

end

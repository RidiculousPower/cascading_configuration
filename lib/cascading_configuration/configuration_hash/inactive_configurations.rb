
class ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations < 
      ::CascadingConfiguration::ConfigurationHash

  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_hash )
    
    child_instance = parent_configuration.dup

    if singleton_configuration = @controller.singleton_configuration( configuration_instance, 
                                                                      configuration_name, 
                                                                      false )
      child_instance.parent = singleton_configuration
    else
      child_instance.parent = parent_configuration
    end

    return child_instance

  end
  
end

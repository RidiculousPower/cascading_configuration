
class ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations < 
      ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations

  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    # we want instance configuration details such as extension modules
    child_configuration = super

    # but inheritance relations need to map to the singleton configuration if it exists
    if ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations === parent_configurations and
       singleton_configuration = @controller.singleton_configuration( parent_configurations.configuration_instance, configuration_name, false )
      child_configuration.register_parent( singleton_configuration )
    end

    return child_configuration

  end
  
end

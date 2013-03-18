
class ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_hash )
    
    # we want instance configuration details such as extension modules
    child_configuration = parent_configuration.class.new_inheriting_instance( configuration_instance, 
                                                                              parent_configuration, 
                                                                              @event )
    
    # but inheritance relations need to map to the singleton configuration if it exists
    singleton_configuration = @controller.singleton_configuration( configuration_instance, configuration_name, false )
    child_configuration.replace_parent( parent_configuration, singleton_configuration ) if singleton_configuration
    
    return child_configuration

  end
  
end

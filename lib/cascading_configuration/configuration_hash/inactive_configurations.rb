
class ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    return parent_configuration.class.new_inheriting_instance( configuration_instance, parent_configuration, @event )

  end
  
end

# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::ObjectConfigurations < 
      ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations

  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    child_configuration = parent_configuration.new_inheriting_object_configuration( configuration_instance, @event )
    
    return child_configuration

  end
  
end

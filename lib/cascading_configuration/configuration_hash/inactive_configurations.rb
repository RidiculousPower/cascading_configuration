# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    return parent_configuration.new_inheriting_inactive_configuration( configuration_instance, @event )
    
  end
  
end

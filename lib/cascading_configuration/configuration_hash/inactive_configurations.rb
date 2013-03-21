# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    return parent_configuration.new_configuration_without_parent( configuration_instance, @event )

  end
  
end

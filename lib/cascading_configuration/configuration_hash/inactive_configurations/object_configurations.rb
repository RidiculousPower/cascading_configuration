# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations::ObjectConfigurations < 
      ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations
  
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_configurations, configuration_name )
    
    if shared_configuration_objects = @controller.objects_sharing_object_configurations( configuration_instance ) and
       shared_configuration_objects.include?( parent_configurations.configuration_instance )

      self[ configuration_name ] = parent_configurations[ configuration_name ]
      
    else
      
      super
      
    end
    
    return configuration_name
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    return parent_configuration.new«inheriting_object_configuration»( configuration_instance, @event )

  end
  
end

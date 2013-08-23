# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations < 
      ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations
  
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_configurations, configuration_name )
    
    if shared_configuration_objects = @controller.objects_sharing_instance_configurations( configuration_instance ) and
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
    
    child_configuration = nil
    
    instance = configuration_instance
    
    case parent_configurations
      when ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations::ObjectConfigurations

        child_configuration = parent_configuration.new«inheriting_object_configuration»( instance, @event )
        parent_instance = parent_configurations.configuration_instance
        # inheritance relations need to map to the singleton configuration if it exists
        singleton_configuration = @controller.configuration( parent_instance, configuration_name, false )
        child_configuration.register_parent( singleton_configuration )
        
      else

        child_configuration = super

    end

    return child_configuration

  end
  
end

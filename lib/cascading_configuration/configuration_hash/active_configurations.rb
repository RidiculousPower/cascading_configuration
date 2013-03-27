# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations < ::CascadingConfiguration::ConfigurationHash
  
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_configurations, configuration_name )
    
    if existing_configuration = self[ configuration_name ]
      parent_configuration = parent_configurations[ configuration_name ]
      case parent_configurations
        when ::CascadingConfiguration::ConfigurationHash::ObjectConfigurations
          singleton_configuration = @controller.local_instance_configuration( parent_configuration.parent.instance, 
                                                                              configuration_name, 
                                                                              false )
          existing_configuration.register_parent( singleton_configuration, @event )
        when ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations
          instance = configuration_instance
          parent = parent_configurations.configuration_instance
          if singleton_configuration = @controller.local_instance_configuration( parent, configuration_name, false ) or
             singleton_configuration = @controller.singleton_configuration( parent, configuration_name, false )
            existing_configuration.register_parent( singleton_configuration )
          end
        else
          @event ? existing_configuration.register_parent_for_ruby_hierarchy( parent_configuration ) 
                 : existing_configuration.register_parent( parent_configuration )
      end
    else
      super
    end

    return configuration_name
    
  end
  
  ###################
  #  post_set_hook  #
  ###################
  
  def post_set_hook( key, configuration )

    @controller.active_configurations( configuration_instance )[ key ] = configuration
    
    return configuration
    
  end

  ######################
  #  post_delete_hook  #
  ######################
  
  def post_delete_hook( key, configuration )
    
    @controller.active_configurations( configuration_instance ).delete( key )
    
    return configuration
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_name, parent_configuration, parent_configurations )
    
    child_configuration = nil

    case parent_configurations
      when ::CascadingConfiguration::ConfigurationHash::ObjectConfigurations
        singleton_configuration = @controller.local_instance_configuration( parent_configuration.parent.instance, 
                                                                            configuration_name, 
                                                                            false )
        child_configuration = singleton_configuration.new_inheriting_configuration( configuration_instance, @event )
      when ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations
        instance = configuration_instance
        parent = parent_configurations.configuration_instance
        child_configuration = parent_configuration.new_inheriting_inactive_configuration( instance, @event )
        if singleton_configuration = @controller.local_instance_configuration( parent, configuration_name, false ) or
           singleton_configuration = @controller.singleton_configuration( parent, configuration_name, false )
          child_configuration.register_parent( singleton_configuration )
        end
      else
        child_configuration = parent_configuration.new_inheriting_configuration( configuration_instance, @event )
    end
    
    return child_configuration

  end
  
end

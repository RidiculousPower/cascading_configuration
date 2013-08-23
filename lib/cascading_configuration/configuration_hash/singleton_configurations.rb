# -*- encoding : utf-8 -*-

class ::CascadingConfiguration::ConfigurationHash::SingletonConfigurations < 
      ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations
    
  #########################
  #  register_parent_key  #
  #########################
  
  def register_parent_key( parent_configurations, configuration_name )

    if shared_configuration_objects = @controller.objects_sharing_singleton_configurations( configuration_instance ) and
       shared_configuration_objects.include?( parent_configurations.configuration_instance )

      self[ configuration_name ] = parent_configurations[ configuration_name ]
      
    else
      
      super
      
    end

    # if we are inheriting from singleton configs we need to provide methods
    # if we are inheriting from instance configs, Ruby provided methods via inheritance
    if ::CascadingConfiguration::ConfigurationHash::SingletonConfigurations === parent_configurations
      parent_configuration = parent_configurations[ configuration_name ]
      configuration_instance.extend( parent_configuration.read_method_module, 
                                     parent_configuration.write_method_module )
    end
          
    return configuration_name
    
  end
  
end

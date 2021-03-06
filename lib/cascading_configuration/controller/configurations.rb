# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller::Configurations

  ##########################
  #  define_configuration  #
  ##########################
  
  ###
  # Define configuration for instance.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param [ CascadingConfiguration::Module::Configuration ]
  #
  #        configuration_instance
  #        
  #        Hash of configuration names pointing to corresponding configuration instances.
  # 
  # @return Self.
  #
  def define_configuration( instance, configuration )
    
    configurations( instance )[ configuration.name ] = configuration
    
    return self
    
  end

  ###################
  #  configuration  #
  ###################
  
  ###
  # Get configuration for instance. Creates configuration for instance if does not already exist for instance
  #   but does exist for instance's class.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @param [Symbol,String]
  #
  #        configuration_name
  #
  #        Configuration name to retrieve.
  #
  # @return [ CascadingConfiguration::Module::Configuration ]
  #
  #         Configuration instance for name on instance.
  #
  def configuration( instance, configuration_name, ensure_exists = true )
    
    configuration_instance = nil
    raise_error = ensure_exists

    unless active_configurations = active_configurations( instance, false ) and
           configuration_instance = active_configurations[ configuration_name = configuration_name.to_sym ]

      singleton_configurations( instance ).load_parent_state
      
      unless active_configurations = active_configurations( instance, false ) and
             configuration_instance = active_configurations[ configuration_name ]
        if ensure_exists
          exception_string = 'No configuration ' << configuration_name.to_s
          exception_string << ' for ' << instance.to_s 
          exception_string << '.'
          raise ::ArgumentError, exception_string
        end
      end

    end
    
    return configuration_instance
    
  end
  
  ###########################
  #  active_configurations  #
  ###########################
  
  def active_configurations( instance, should_create = true )
    
    unless active_configurations = @active_configurations[ instance_id = instance.__id__ ]
      @active_configurations[ instance_id ] = active_configurations = { } if should_create
    end
    
    return active_configurations
    
  end

  ##############################
  #  singleton_configurations  #
  ##############################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [Object] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [CascadingConfiguration::ConfigurationHash{Symbol,String => CascadingConfiguration::Module}]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def singleton_configurations( instance, should_create = true )
    
    configurations = nil
    
    case instance
      when ::Module
        unless configurations = @singleton_configurations[ instance_id = instance.__id__ ]
          if should_create
            configurations = ::CascadingConfiguration::ConfigurationHash::SingletonConfigurations.new( self, instance )            
            unless ::Class === instance
              configurations.register_parent( instance_configurations( instance_class = instance.class ) )
              configurations.register_parent( object_configurations( instance_class ) )
            end
            @singleton_configurations[ instance_id ] = configurations
          end
        end
      else
        configurations = instance_configurations( instance, should_create )
    end
    
    return configurations

  end

  #############################
  #  instance_configurations  #
  #############################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [Object] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [CascadingConfiguration::ConfigurationHash{Symbol,String => CascadingConfiguration::Module}]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def instance_configurations( instance, should_create = true )
    
    configurations = nil

    unless configurations = @instance_configurations[ instance_id = instance.__id__ ]
      if should_create
        case instance
          when ::Module
            configurations = ::CascadingConfiguration::ConfigurationHash::
                               InactiveConfigurations::InstanceConfigurations.new( self, instance )
          else
            configurations = ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations.new( self, instance )
            configurations.register_parent( instance_configurations( instance.class ) )
            configurations.register_parent( object_configurations( instance.class ) )
        end
        @instance_configurations[ instance_id ] = configurations
      end
    end
    
    return configurations

  end

  ###################################
  #  local_instance_configurations  #
  ###################################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [Object] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [CascadingConfiguration::ConfigurationHash{Symbol,String => CascadingConfiguration::Module}]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def local_instance_configurations( instance, should_create = true )
    
    configurations = nil
    
    unless configurations = @local_instance_configurations[ instance_id = instance.__id__ ]
      if should_create
        configurations = ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations.new( self, instance )
        @local_instance_configurations[ instance_id ] = configurations
      end
    end
    
    return configurations

  end

  ###########################
  #  object_configurations  #
  ###########################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [Object] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [CascadingConfiguration::ConfigurationHash{Symbol,String => CascadingConfiguration::Module}]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def object_configurations( instance, should_create = true )
    
    configurations = nil
    
    case instance
      when ::Module

        unless configurations = @object_configurations[ instance_id = instance.__id__ ]
          if should_create
            configurations = ::CascadingConfiguration::ConfigurationHash::
                               InactiveConfigurations::ObjectConfigurations.new( self, instance )
            @object_configurations[ instance_id ] = configurations
          end
        end

      else

        configurations = instance_configurations( instance )
        
    end
    
    
    return configurations

  end
  
  #############################
  #  singleton_configuration  #
  #############################
  
  def singleton_configuration( instance, configuration_name, ensure_exists = true )

    configuration_instance = nil

    unless singleton_configurations = singleton_configurations( instance, false ) and
           configuration_instance = singleton_configurations[ configuration_name = configuration_name.to_sym ]
      if ensure_exists
        exception_string = 'No singleton configuration ' << configuration_name.to_s
        exception_string << ' for ' << instance.to_s 
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end
  
    return configuration_instance
    
  end
  
  ############################
  #  instance_configuration  #
  ############################
  
  def instance_configuration( instance, configuration_name, ensure_exists = true )

    configuration_instance = nil

    unless instance_configurations = instance_configurations( instance, false ) and
           configuration_instance = instance_configurations[ configuration_name = configuration_name.to_sym ]
      if ensure_exists
        exception_string = 'No instance configuration ' << configuration_name.to_s
        exception_string << ' for ' << instance.to_s 
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end

    return configuration_instance
    
  end
  
  ##########################
  #  object_configuration  #
  ##########################
  
  def object_configuration( instance, configuration_name, ensure_exists = true )

    configuration_instance = nil

    unless object_configurations = object_configurations( instance, false ) and
           configuration_instance = object_configurations[ configuration_name = configuration_name.to_sym ]
      if ensure_exists
        exception_string = 'No local instance configuration ' << configuration_name.to_s
        exception_string << ' for ' << instance.to_s 
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end
    
    return configuration_instance
    
  end
  
  ##################################
  #  local_instance_configuration  #
  ##################################
  
  def local_instance_configuration( instance, configuration_name, ensure_exists = true )
    
    configuration_instance = nil
    
    unless local_instance_configurations = local_instance_configurations( instance, false ) and
           configuration_instance = local_instance_configurations[ configuration_name = configuration_name.to_sym ]
      if ensure_exists
        exception_string = 'No object configuration ' << configuration_name.to_s
        exception_string << ' for ' << instance.to_s 
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end
    
    return configuration_instance
    
  end
  
end

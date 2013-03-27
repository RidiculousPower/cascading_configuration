# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller

  extend ::Forwardable

  extend ::Module::Cluster  
  cluster( :cascading_configuration_controller ).before_extend do |controller_instance|
    controller_instance.instance_eval do
      @active_configurations = { }
      @singleton_configurations = { }
      @instance_configurations = { }
      @object_configurations = { }
      @local_instance_configurations = { }
    end
  end
  
  ##############
  #  included  #
  ##############
  
  ###
  # Include causes all defined cascading configuration modules to be included.
  #
  def included( instance )
    
    super if defined?( super )
    
    _configuration_modules = configuration_modules
    instance.module_eval { _configuration_modules.each { |this_member| include( this_member ) } }
    
  end

  ##############
  #  extended  #
  ##############
  
  ###
  # Extend causes all defined cascading configuration modules to be extended.
  #
  def extended( instance )
    
    super if defined?( super )
    
    configuration_modules.each { |this_member| instance.extend( this_member ) }
    
  end

  ################################
  #  create_instance_controller  #
  ################################
  
  def_instance_delegator ::CascadingConfiguration::InstanceController, :create_instance_controller
  
  #########################
  #  instance_controller  #
  #########################
  
  def_instance_delegator ::CascadingConfiguration::InstanceController, :instance_controller
  
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
            if ( instance_class = instance.class ) < ::Module and not instance_class < ::Class
              configurations = ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations.new( self, instance )
            else
              configurations = ::CascadingConfiguration::ConfigurationHash::ActiveConfigurations.new( self, instance )
            end
            @singleton_configurations[ instance_id ] = configurations
            ensure_no_unregistered_superclass( instance )
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
        @instance_configurations[ instance_id ] = configurations = case instance
          when ::Module
            ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations.new( self, instance )
          else
            ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations.new( self, instance )
        end
        ensure_no_unregistered_superclass( instance )
      end
    end
    
    return configurations

  end

  ####################################
  #  local_instance_configurations  #
  ####################################
  
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
    
    unless configurations = @object_configurations[ instance_id = instance.__id__ ]
      if should_create
        configurations = ::CascadingConfiguration::ConfigurationHash::ObjectConfigurations.new( self, instance )
        @object_configurations[ instance_id ] = configurations
      end
    end
    
    return configurations

  end

  #######################################
  #  ensure_no_unregistered_superclass  #
  #######################################
  
  def ensure_no_unregistered_superclass( instance )
    
    had_unregistered_superclass = false
    
    if ::Class === instance and ! instance.equal?( ::Class )
      # We want to know if we have a class above us that has configurations that we did not receive.
      # This happens if we had already initialized the subclass before CC was added to the class above us.
      # This could be multiple classes - so we could have D, ..., A where A has configs.
      # It can't be modules because including them would call their hook, initializing the instance.
      # So we need the next class and if it hasn't initialized, 
      # find the next class - if it has initialized, register it as our parent
      instance.ancestors.each do |this_ancestor|
        next if this_ancestor.equal?( instance )
        if ::Class === this_ancestor
          break if this_ancestor >= ::Class
          ensure_no_unregistered_superclass( this_ancestor )
          if has_singleton_configurations?( this_ancestor ) or 
             has_instance_configurations?( this_ancestor )
            register_parent( instance, this_ancestor, :subclass )
          end
          break
        end
      end
    end
    
    return had_unregistered_superclass
    
  end

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

  ###################################
  #  has_singleton_configurations?  #
  ###################################

  def has_singleton_configurations?( instance )
    
    return singleton_configurations( instance, false ) ? true : false
    
  end

  ##################################
  #  has_instance_configurations?  #
  ##################################
  
  def has_instance_configurations?( instance )

    return instance_configurations( instance, false ) ? true : false

  end
  
  ################################
  #  has_object_configurations?  #
  ################################

  def has_object_configurations?( instance )

    return object_configurations( instance, false ) ? true : false

  end

  #########################################
  #  has_local_instance_configurations?  #
  #########################################
  
  def has_local_instance_configurations?( instance )

    return local_instance_configurations( instance, false ) ? true : false

  end

  ########################
  #  has_configuration?  #
  ########################

  def has_configuration?( instance, configuration_name, ensure_exists = false )

    return configuration( instance, configuration_name, ensure_exists ) ? true : false

  end

  ##################################
  #  has_singleton_configuration?  #
  ##################################

  def has_singleton_configuration?( instance, configuration_name, ensure_exists = false )
    
    return singleton_configuration( instance, configuration_name, ensure_exists ) ? true : false
    
  end

  #################################
  #  has_instance_configuration?  #
  #################################
  
  def has_instance_configuration?( instance, configuration_name, ensure_exists = false )

    return instance_configuration( instance, configuration_name, ensure_exists ) ? true : false

  end
  
  ###############################
  #  has_object_configuration?  #
  ###############################

  def has_object_configuration?( instance, configuration_name, ensure_exists = false )

    return object_configuration( instance, configuration_name, ensure_exists ) ? true : false

  end

  ########################################
  #  has_local_instance_configuration?  #
  ########################################
  
  def has_local_instance_configuration?( instance, configuration_name, ensure_exists = false )

    return local_instance_configuration( instance, configuration_name, ensure_exists ) ? true : false

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

    unless active_configurations = active_configurations( instance, false ) and
           configuration_instance = active_configurations[ configuration_name.to_sym ]
      if ensure_exists
        exception_string = 'No configuration ' << configuration_name.to_s
        exception_string << ' for ' << instance.to_s 
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end
    
    return configuration_instance
    
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
  
  ###################################
  #  local_instance_configuration  #
  ###################################
  
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
  
  #####################
  #  register_parent  #
  #####################
  
  ###
  # Runs #register_parent for each configuration in parent.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which parent will be registered.
  #
  # @param [Object]
  #
  #        parent
  #
  #        Parent to be registered for instance.
  #
  # @return 
  #
  def register_parent( instance, parent, event = nil )

    super( instance, parent )
    
    case event

      when :include, :subclass
        
        # singleton => singleton
        if parent_singleton_configurations = singleton_configurations( parent, false )
          singleton_configurations( instance ).register_parent( parent_singleton_configurations, event )
        end
        # instance => instance
        if parent_instance_configurations = instance_configurations( parent, false )
          instance_configurations( instance ).register_parent( parent_instance_configurations, event )
        end
        # object => object
        if parent_object_configurations = object_configurations( parent, false )
          object_configurations( instance ).register_parent( parent_object_configurations, event )
        end

      when :extend
        
        case instance
          when ::Module
            singleton_configurations = nil
            # instance => singleton
            if parent_instance_configurations = instance_configurations( parent, false )
              singleton_configurations = singleton_configurations( instance )
              singleton_configurations.register_parent( parent_instance_configurations, event )
            end
            # object => singleton
            if parent_object_configurations = object_configurations( parent, false )
              singleton_configurations ||= singleton_configurations( instance )
              singleton_configurations.register_parent( parent_object_configurations, event )
            end
          else
            instance_configurations = nil
            # instance => instance
            if parent_instance_configurations = instance_configurations( parent, false )
              instance_configurations = instance_configurations( instance )
              instance_configurations.register_parent( parent_instance_configurations, event )
            end
            # object => instance
            if parent_object_configurations = object_configurations( parent, false )
              instance_configurations ||= instance_configurations( instance )
              instance_configurations.register_parent( parent_object_configurations, event )
            end
        end

      when :instance

        if ( instance_class = instance.class ) < ::Module and not instance_class < ::Class

          singleton_configurations = nil

          # instance => singleton
          if parent_instance_configurations = instance_configurations( parent, false )
            singleton_configurations = singleton_configurations( instance )
            singleton_configurations.register_parent( parent_instance_configurations, event )
          end
          # object => singleton
          if parent_object_configurations = object_configurations( parent, false )
            singleton_configurations ||= singleton_configurations( instance )
            singleton_configurations.register_parent( parent_object_configurations, event )
          end

        else

          instance_configurations = nil

          # instance => instance
          if parent_instance_configurations = instance_configurations( parent, false )
            instance_configurations = instance_configurations( instance )
            instance_configurations.register_parent( parent_instance_configurations, event )
          end
          # object => instance
          if parent_object_configurations = object_configurations( parent, false )
            instance_configurations ||= instance_configurations( instance )
            instance_configurations.register_parent( parent_object_configurations, event )
          end

        end
        
      when :singleton_to_instance
        
        # singleton => instance
        if parent_singleton_configurations = singleton_configurations( parent, false )
          instance_configurations = instance_configurations( instance )
          instance_configurations.register_parent( parent_singleton_configurations )
        end
        
      when nil
        
        case parent
          
          when ::Module

            instance_configurations = nil
            
            if ::Module === instance

              # singleton => singleton
              if parent_singleton_configurations = singleton_configurations( parent, false )
                singleton_configurations( instance ).register_parent( parent_singleton_configurations )
              end
              # object => object
              if parent_object_configurations = object_configurations( parent, false )
                object_configurations( instance ).register_parent( parent_object_configurations )
              end

            else

              # object => instance
              if parent_object_configurations = object_configurations( parent, false )
                instance_configurations = instance_configurations( instance )
                instance_configurations.register_parent( parent_object_configurations )
              end
              
            end

            # instance => instance
            if parent_instance_configurations = instance_configurations( parent, false )
              instance_configurations ||= instance_configurations( instance )
              instance_configurations.register_parent( parent_instance_configurations )
            end
            
          else

            # inheriting from instance to module or class or other instance
            # we have only instance configurations, so we have to decide what that means for module or class
            # we make both singleton and instance configurations inherit from instance
            
            singleton_configurations = nil
            instance_configurations = nil
            
            if parent_instance_configurations = instance_configurations( parent, false )
              # instance => instance
              instance_configurations = instance_configurations( instance )
              instance_configurations.register_parent( parent_instance_configurations )
              if ::Module === instance
                # instance => singleton
                singleton_configurations = singleton_configurations( instance )
                singleton_configurations.register_parent( parent_instance_configurations )
              end
            end

            # object => instance
            if parent_object_configurations = object_configurations( parent, false )
              instance_configurations ||= instance_configurations( instance )
              instance_configurations( instance ).register_parent( parent_object_configurations )
              if ::Module === instance
                # object => singleton
                singleton_configurations ||= singleton_configurations( instance )
                singleton_configurations( instance ).register_parent( parent_object_configurations )
              end
            end

        end

    end
              
    return self
    
  end
  
  #######################
  #  unregister_parent  #
  #######################
  
  ###
  # Runs #unregister_parent for each configuration in parent.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which parent will be unregistered.
  #
  # @param [Object]
  #
  #        parent
  #
  #        Parent to be unregistered for instance.
  #
  # @return 
  #
  def unregister_parent( instance, parent )
    
    super
    
    case instance
      when ::Module
        if ( instance_class = instance.class ) < ::Module and not instance_class < ::Class
          if parent_instance_configurations = instance_configurations( parent )
            singleton_configurations( instance ).unregister_parent( parent_instance_configurations )
          end
        else
          if parent_singleton_configurations = singleton_configurations( parent )
            singleton_configurations( instance ).unregister_parent( parent_singleton_configurations )
          end
          if parent_instance_configurations = instance_configurations( parent )
            instance_configurations( instance ).unregister_parent( parent_instance_configurations )
          end
        end
      else
        if parent_instance_configurations = instance_configurations( parent )
          instance_configurations( instance ).unregister_parent( parent_instance_configurations )
        end
    end

    return self
    
  end

  ####################
  #  replace_parent  #
  ####################
  
  ###
  # Runs #replace_parent for each configuration in parent.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which parent will be replaceed.
  #
  # @param [Object]
  #
  #        parent
  #
  #        Parent to be replaced for instance.
  #
  # @param [Object]
  #
  #        new_parent
  #
  #        Parent to replace old parent.
  #
  # @return Self.
  #
  def replace_parent( instance, parent, new_parent, event = nil )
    
    unregister_parent( instance, parent )
    register_parent( instance, new_parent, event )
    
    return self
    
  end

  #########################
  #  has_configurations?  #
  #########################
  
  ###
  # Query whether any configurations exist for instance.
  #
  # @param [Object]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [ true, false ] 
  #
  #         Whether configurations exist for instance.
  #
  def has_configurations?( instance )
    
    return ! active_configurations( instance ).empty?
    
  end

  ########################
  #  has_configuration?  #
  ########################

  ###
  # Query whether configuration has been registered for instance.
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
  #        Name of configuration.
  #
  # @return [ true, false ] 
  #
  #         Whether configuration has been registered for instance.
  #
  def has_configuration?( instance, configuration_name )

    return active_configurations( instance ).has_key?( configuration_name.to_sym )

  end

  ##########################
  #  remove_configuration  #
  ##########################
  
  ###
  # Unregister configuration for instance.
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
  #        Name of configuration.
  #
  def remove_configuration( instance, configuration_name )
    
    remove_configuration = nil
    
    if has_object_configuration?( instance, configuration_name, false)
      removed_configuration = remove_object_configuration( instance, configuration_name )
    else
      case instance
        when ::Module
          removed_configuration = remove_singleton_configuration( instance, configuration_name )
        else
          removed_configuration = remove_instance_configuration( instance, configuration_name )
      end
    end    
    
    return removed_configuration

  end

  ####################################
  #  remove_singleton_configuration  #
  ####################################
  
  ###
  # Unregister configuration for instance.
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
  #        Name of configuration.
  #
  def remove_singleton_configuration( instance, configuration_name )
    
    removed_configuration = nil
    
    if singleton_configurations = singleton_configurations( instance, false )
      removed_configuration = singleton_configurations.delete( configuration_name )
    end
    
    return removed_configuration

  end
  
  ###################################
  #  remove_instance_configuration  #
  ###################################
  
  ###
  # Unregister configuration for instance.
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
  #        Name of configuration.
  #
  def remove_instance_configuration( instance, configuration_name )
    
    removed_configuration = nil
    
    if instance_configurations = instance_configurations( instance, false )
      removed_configuration = instance_configurations.delete( configuration_name )
    end
    
    return removed_configuration

  end
  
  #########################################
  #  remove_object_configuration  #
  #########################################
  
  ###
  # Unregister configuration for instance.
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
  #        Name of configuration.
  #
  def remove_object_configuration( instance, configuration_name )
    
    removed_configuration = nil
    
    if object_configurations = object_configurations( instance, false )
      removed_configuration = object_configurations.delete( configuration_name )
    end
    
    return removed_configuration

  end
  
  ##########################################
  #  remove_local_instance_configuration  #
  ##########################################
  
  ###
  # Unregister configuration for instance.
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
  #        Name of configuration.
  #
  def remove_local_instance_configuration( module_or_class_instance, configuration_name )
    
    removed_configuration = nil
    
    if local_instance_configurations = local_instance_configurations( module_or_class_instance, false )
      removed_configuration = local_instance_configurations.delete( configuration_name )
    end
    
    return removed_configuration

  end
  
end

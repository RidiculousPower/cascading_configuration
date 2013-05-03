# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller

  include ::ParallelAncestry
  extend ::Forwardable

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( instance )
    
    super
    
    instance.instance_eval do
      @active_configurations = { }
      @singleton_configurations = { }
      @instance_configurations = { }
      @object_configurations = { }
      @local_instance_configurations = { }
      @objects_sharing_singleton_configurations = { }
      @objects_sharing_instance_configurations = { }
      @objects_sharing_object_configurations = { }
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

  ##############################
  #  share_all_configurations  #
  ##############################
  
  def share_all_configurations( for_instance, with_instance )
    
    case for_instance
      when ::Module
        share_all_singleton_configurations( for_instance, with_instance )
        share_all_object_configurations( for_instance, with_instance )
    end
    
    share_all_instance_configurations( for_instance, with_instance )
    
    return self
    
  end
  
  ########################################
  #  share_all_singleton_configurations  #
  ########################################

  def share_all_singleton_configurations( for_instance, with_instance )
    
    shared_configurations = singleton_configurations( with_instance )

    case for_instance
      when ::Module
        @singleton_configurations[ for_instance.__id__ ] = shared_configurations
      else
        @instance_configurations[ for_instance.__id__ ] = shared_configurations
    end
    
    return shared_configurations
    
  end

  #######################################
  #  share_all_instance_configurations  #
  #######################################

  def share_all_instance_configurations( for_instance, with_instance )

    @instance_configurations[ for_instance.__id__ ] = shared_configurations = instance_configurations( with_instance )

    return shared_configurations
    
  end

  #####################################
  #  share_all_object_configurations  #
  #####################################

  def share_all_object_configurations( for_instance, with_instance )

    shared_configurations = object_configurations( with_instance )

    case for_instance
      when ::Module
        @object_configurations[ for_instance.__id__ ] = shared_configurations
      else
        @instance_configurations[ for_instance.__id__ ] = shared_configurations
    end
    
    return shared_configurations
    
  end
  
  ##############################################
  #  objects_sharing_singleton_configurations  #
  ##############################################
  
  def objects_sharing_singleton_configurations( for_instance, should_create = false )
    
    unless objects = @objects_sharing_singleton_configurations[ for_instance_id = for_instance.__id__ ]
      if should_create
        @objects_sharing_singleton_configurations[ for_instance_id ] = objects = ::Array::UniqueByID.new
      end
    end
    
    return objects
    
  end

  #############################################
  #  objects_sharing_instance_configurations  #
  #############################################
  
  def objects_sharing_instance_configurations( for_instance, should_create = false )
    
    unless objects = @objects_sharing_instance_configurations[ for_instance_id = for_instance.__id__ ]
      if should_create
        @objects_sharing_instance_configurations[ for_instance_id ] = objects = ::Array::UniqueByID.new
      end
    end
    
    return objects
    
  end

  ###########################################
  #  objects_sharing_object_configurations  #
  ###########################################

  def objects_sharing_object_configurations( for_instance, should_create = false )
    
    unless objects = @objects_sharing_object_configurations[ for_instance_id = for_instance.__id__ ]
      if should_create
        @objects_sharing_object_configurations[ for_instance_id ] = objects = ::Array::UniqueByID.new
      end
    end
    
    return objects
    
  end

  ##########################
  #  share_configurations  #
  ##########################
  
  def share_configurations( for_instance, with_instance )
    
    case for_instance
      when ::Module
        share_singleton_configurations( for_instance, with_instance )
        share_object_configurations( for_instance, with_instance )
    end
    
    share_instance_configurations( for_instance, with_instance )
    
    return self
    
  end

  ####################################
  #  share_singleton_configurations  #
  ####################################

  def share_singleton_configurations( with_instance, from_instance )

    objects_sharing_singleton_configurations( with_instance, true ).push( from_instance )
    singleton_configurations( with_instance ).share_configurations( singleton_configurations( from_instance ) )
    
    return self
    
  end

  ###################################
  #  share_instance_configurations  #
  ###################################

  def share_instance_configurations( with_instance, from_instance )

    objects_sharing_instance_configurations( with_instance, true ).push( from_instance )
    instance_configurations( with_instance ).share_configurations( instance_configurations( from_instance ) )

    return self
    
  end

  #################################
  #  share_object_configurations  #
  #################################

  def share_object_configurations( with_instance, from_instance )

    objects_sharing_object_configurations( with_instance, true ).push( from_instance )
    object_configurations( with_instance ).share_configurations( object_configurations( from_instance ) )

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

    unless active_configurations = active_configurations( instance, false ) and
           configuration_instance = active_configurations[ configuration_name.to_sym ]
      # we don't want to ensure unless we failed to find what we expected
      if ensure_no_unregistered_ancestor( instance, configuration_name )
        # if we had an unregistered superclass, ask again for the configuration
        configuration_instance = configuration( instance, configuration_name, ensure_exists )
      elsif ensure_exists
        exception_string = 'No configuration ' << configuration_name.to_s
        exception_string << ' for ' << instance.to_s 
        exception_string << '.'
        raise ::ArgumentError, exception_string
      end
    end
    
    return configuration_instance
    
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
            is_module_subclass = ! ( ::Class === instance ) and 
                                 ( instance_class = instance.class ) < ::Module and not instance_class < ::Class
            configurations = is_module_subclass ? ::CascadingConfiguration::ConfigurationHash::
                                                    InstanceConfigurations.new( self, instance )
                                                : ::CascadingConfiguration::ConfigurationHash::
                                                    SingletonConfigurations.new( self, instance )
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
        @instance_configurations[ instance_id ] = configurations = case instance
          when ::Module
            ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations.new( self, instance )
          else
            ::CascadingConfiguration::ConfigurationHash::InstanceConfigurations.new( self, instance )
        end
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
            configurations = ::CascadingConfiguration::ConfigurationHash::InactiveConfigurations::ObjectConfigurations.new( self, instance )
            @object_configurations[ instance_id ] = configurations
          end
        end

      else

        configurations = instance_configurations( instance )
        
    end
    
    
    return configurations

  end
  
  #####################################
  #  ensure_no_unregistered_ancestor  #
  #####################################
  
  def ensure_no_unregistered_ancestor( instance, missing_configuration_name )
    
    # We want to know if we have a class above us that has configurations that we did not receive.
    # This happens if:
    # * a module is included/extended in sub-module before configurations are created for module
    # * a subclass is created before configurations are created for class
    # * an instance has just been created

    had_unregistered_superclass = false

    # if we try to register Class or above we get stuck in a loop
    unless instance.equal?( ::Class )
      
      case instance
    
        when ::Module

          instance.ancestors.each_range( 1 ) do |this_ancestor|
            break unless this_ancestor.method_defined?( missing_configuration_name )
            if ensure_no_unregistered_ancestor( this_ancestor, missing_configuration_name ) or
               has_singleton_configurations?( this_ancestor )                               or 
               has_instance_configurations?( this_ancestor )
              had_unregistered_superclass = true
              case instance
                when ::Class
                  register_parent( instance, this_ancestor, :subclass )
                else
                  register_parent( instance, this_ancestor, :include )
              end
            end
            # lookup through the ancestor chain occurs recursively, so the first time we get here we are done
            break
          end
    
        else

          if has_singleton_configurations?( instance_class = instance.class )     or 
             has_instance_configurations?( instance_class )      or
             ensure_no_unregistered_ancestor( instance_class )

            had_unregistered_superclass = true
            register_parent( instance, instance_class, :instance )

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

        if ! ( ::Class === instance ) and 
           ( instance_class = instance.class ) < ::Module and not instance_class < ::Class

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
        if ! ( ::Class === instance ) and 
           ( instance_class = instance.class ) < ::Module and not instance_class < ::Class
          if parent_instance_configurations = instance_configurations( parent, false )
            if singleton_configurations = singleton_configurations( instance, false )
              singleton_configurations.unregister_parent( parent_instance_configurations )
            end
          end
        else
          if parent_singleton_configurations = singleton_configurations( parent, false )
            if singleton_configurations = singleton_configurations( instance, false )
              singleton_configurations.unregister_parent( parent_singleton_configurations )
            end
          end
          if parent_instance_configurations = instance_configurations( parent, false )
            if instance_configurations = instance_configurations( instance, false )
              instance_configurations.unregister_parent( parent_instance_configurations )
            end
          end
        end
      else
        parent_configurations = case parent
          when ::Module
            singleton_configurations( parent, false )
          else
            instance_configurations( parent, false )
        end
        instance_configurations( instance ).unregister_parent( parent_configurations ) if parent_configurations
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

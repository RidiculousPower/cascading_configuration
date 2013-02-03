
begin ; require 'development' ; rescue ::LoadError ; end

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

module ::CascadingConfiguration
  
  extend ::ParallelAncestry
  
  @configurations = ::CascadingConfiguration::AutoNestingIDHash.new
  
  ###################
  #  self.included  #
  ###################
  
  ###
  # Include causes all defined cascading configuration modules to be included.
  #
  def self.included( instance )
    
    super if defined?( super )
    
    configuration_modules = ::CascadingConfiguration.configuration_modules
    
    instance.module_eval do
      configuration_modules.each do |this_member|
        include( this_member )
      end
    end
    
  end

  ###################
  #  self.extended  #
  ###################
  
  ###
  # Extend causes all defined cascading configuration modules to be extended.
  #
  def self.extended( instance )
    
    super if defined?( super )
    
    configuration_modules = ::CascadingConfiguration.configuration_modules
    
    configuration_modules.each do |this_member|
      instance.extend( this_member )
    end
    
  end

  #####################################
  #  self.create_instance_controller  #
  #####################################
  
  def self.create_instance_controller( instance, extending = false )
    
    return ::CascadingConfiguration::InstanceController.create_instance_controller( instance, extending )
    
  end
  
  ##############################
  #  self.instance_controller  #
  ##############################
  
  def self.instance_controller( instance, ensure_exists = false )
    
    return ::CascadingConfiguration::InstanceController.instance_controller( instance, ensure_exists )
    
  end
  
  #########################
  #  self.configurations  #
  #########################
  
  ###
  # Get hash of configurations names and their corresponding configuration instances.
  #
  # @param [ Object ] instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [ Hash{ Symbol, String => CascadingConfiguration::Module } ]
  #
  #         Hash of configuration names pointing to corresponding configuration instances.
  # 
  def self.configurations( instance )
    
    # the first time we get configurations for instance, register configurations defined in class
    unless @configurations.has_key?( instance ) or instance.equal?( ::Class )
      # create the instance_configurations hash so it won't loop
      @configurations[ instance ]
      register_parent( instance, instance.class )
    end
    
    return @configurations[ instance ]

  end

  ###############################
  #  self.define_configuration  #
  ###############################
  
  ###
  # Define configuration for instance.
  #
  # @param [ Object ]
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
  def self.define_configuration( instance, configuration_instance )
    
    configurations( instance )[ configuration_instance.name ] = configuration_instance
    
    return self
    
  end

  ########################
  #  self.configuration  #
  ########################
  
  ###
  # Get configuration for instance. Creates configuration for instance if does not already exist for instance
  #   but does exist for instance's class.
  #
  # @param [ Object ]
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
  def self.configuration( instance, configuration_name )
    
    unless configuration_instance = configurations( instance )[ configuration_name.to_sym ]
      raise ::ArgumentError, 'No configuration ' << configuration_name.to_s + ' for ' << instance.to_s + '.'
    end
    
    return configuration_instance
    
  end
  
  ##########################
  #  self.register_parent  #
  ##########################
  
  ###
  # Runs #register_parent for each configuration in parent.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which parent will be registered.
  #
  # @param [ Object ]
  #
  #        parent
  #
  #        Parent to be registered for instance.
  #
  # @return self.
  #
  def self.register_parent( instance, parent, include_extend_subclass_instance = nil )
    
    super( instance, parent )
    
    parent_configurations = configurations( parent )

    # singleton => singleton
    # instance => instance
    # instance => singleton
    # singleton => instance
    
    # :singleton_to_singleton_and_instance_to_instance
    # singleton => singleton and instance => instance
    # :instance_to_instance
    # instance => instance
    # :singleton_to_instance
    # singleton => instance
    # :instance_to_singleton
    # instance => singleton
    
    cascade_configurations = nil
    
    case include_extend_subclass_instance

      when :include
        
        case instance
          when ::Module, ::Class
            # * module => class
            #   singleton => singleton
            #   instance => instance
            # * module => module
            #   singleton => singleton
            #   instance => instance
            cascade_configurations = :singleton_to_singleton_and_instance_to_instance
        end
        
      when :extend
        
        # * module => class
        #   instance => singleton
        # * module => module
        #   instance => singleton
        # * module => instance (extend)
        #   instance => singleton
        cascade_configurations = :instance_to_singleton
    
      when :subclass
        
        # * class < module => class < module
        #   singleton => singleton
        #   instance => instance
        # * class => class
        #   singleton => singleton
        #   instance => instance
        cascade_configurations = :singleton_to_singleton_and_instance_to_instance
    
      when :instance

        instance_class = instance.class
        if instance_class < ::Module and not instance_class < ::Class
          # * instance of class < module (a Module)
          #   singleton => instance
          cascade_configurations = :singleton_to_instance
        else
          # * instance of class (an Object)
          #   instance => instance
          cascade_configurations = :instance_to_instance
        end
      
      when nil
        
        case parent
          when ::Class
            case instance
              when ::Class, ::Module
                # * class => class
                #   singleton => singleton
                #   instance => instance
                # * class => module
                #   singleton => singleton
                #   instance => instance
                cascade_configurations = :singleton_to_singleton_and_instance_to_instance
              else
                # * class => instance
                #   instance => instance
                cascade_configurations = :instance_to_instance
            end
          when ::Module
            case instance
              when ::Class, ::Module
                # * module => module
                #   singleton => singleton
                #   instance => instance
                # * module => class
                #   singleton => singleton
                #   instance => instance
                cascade_configurations = :singleton_to_singleton_and_instance_to_instance
              else
                # * module => instance
                #   instance => instance
                cascade_configurations = :instance_to_instance
            end
          else
            # * instance => instance
            #   singleton => singleton
            #   instance => instance
            cascade_configurations = :singleton_to_singleton_and_instance_to_instance
        end
    
      when :singleton_to_singleton

        cascade_configurations = :singleton_to_singleton
      
    end
    
    case cascade_configurations
      when :singleton_to_singleton_and_instance_to_instance
        parent_configurations.each do |this_configuration_name, this_parent_configuration|
          case this_parent_configuration.cascade_type
            when :local_instance, :object
              # nothing to do
            else
              register_child_configuration( instance, this_configuration_name, this_parent_configuration )
          end
        end
      when :instance_to_instance
        parent_configurations.each do |this_configuration_name, this_parent_configuration|
          case this_parent_configuration.cascade_type
            when :instance
              register_child_configuration( instance, this_configuration_name, this_parent_configuration )
            when :singleton_and_instance
              register_child_configuration( instance, this_configuration_name, this_parent_configuration, :instance )
          end
        end
      when :instance_to_singleton
        case this_parent_configuration.cascade_type
          when :instance
            register_child_configuration( instance, this_configuration_name, this_parent_configuration )
          when :singleton_and_instance
            register_child_configuration( instance, this_configuration_name, this_parent_configuration, :singleton )
        end
      when :singleton_to_singleton
        parent_configurations.each do |this_configuration_name, this_parent_configuration|
          case this_parent_configuration.cascade_type
            when :singleton
              register_child_configuration( instance, this_configuration_name, this_parent_configuration )
            when :singleton_and_instance
              register_child_configuration( instance, this_configuration_name, this_parent_configuration, :singleton )
          end
        end
    end
          
    return self
    
  end
  
  #######################################
  #  self.register_child_configuration  #
  #######################################
  
  def self.register_child_configuration( instance, 
                                         configuration_name, 
                                         parent_configuration_instance, 
                                         cascade_type = :singleton_and_instance )

    instance_configurations = configurations( instance )

    if configuration_instance = instance_configurations[ configuration_name ]
      configuration_instance.register_parent( parent )
    else
      configuration_class = parent_configuration_instance.class
      configuration_instance = configuration_class.new( instance, parent_configuration_instance )
      if cascade_type
        configuration_instance.cascade_type = cascade_type
      end
      instance_configurations[ configuration_name ] = configuration_instance
    end
    
    return self

  end

  ############################
  #  self.unregister_parent  #
  ############################
  
  ###
  # Runs #unregister_parent for each configuration in parent.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which parent will be unregistered.
  #
  # @param [ Object ]
  #
  #        parent
  #
  #        Parent to be unregistered for instance.
  #
  # @return self.
  #
  def self.unregister_parent( instance, parent )
    
    super
    
    configurations( instance ).each do |this_configuration_name, this_configuration_instance|
      this_configuration_instance.unregister_parent( parent )
    end
        
    return self
    
  end

  #########################
  #  self.replace_parent  #
  #########################
  
  ###
  # Runs #replace_parent for each configuration in parent.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which parent will be replaceed.
  #
  # @param [ Object ]
  #
  #        parent
  #
  #        Parent to be replaced for instance.
  #
  # @param [ Object ]
  #
  #        new_parent
  #
  #        Parent to replace old parent.
  #
  # @return Self.
  #
  def self.replace_parent( instance, parent, new_parent )
    
    configurations( instance ).each do |this_configuration_name, this_configuration_instance|
      this_configuration_instance.replace_parent( parent, new_parent )
    end
        
    return self
    
  end

  ##############################
  #  self.has_configurations?  #
  ##############################
  
  ###
  # Query whether any configurations exist for instance.
  #
  # @param [ Object ]
  #
  #        instance
  #
  #        Instance for which configurations are being queried.
  #
  # @return [ true, false ] 
  #
  #         Whether configurations exist for instance.
  #
  def self.has_configurations?( instance )
    
    return ! configurations( instance ).empty?
    
  end

  #############################
  #  self.has_configuration?  #
  #############################

  ###
  # Query whether configuration has been registered for instance.
  #
  # @param [ Object ]
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
  def self.has_configuration?( instance, configuration_name )

    return configurations( instance ).has_key?( configuration_name.to_sym )

  end

  ###############################
  #  self.remove_configuration  #
  ###############################
  
  ###
  # Unregister configuration for instance.
  #
  # @param [ Object ]
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
  def self.remove_configuration( instance, configuration_name )
    
    return configurations( instance ).delete( configuration_name )

  end
    
end

# -*- encoding : utf-8 -*-

###
# @private
#
# Each declared configuration is backed by a Configuration object, 
#   which manages details specific to the configuration.
#
class ::CascadingConfiguration::Module::Configuration
  
  ################
  #  initialize  #
  ################
  
  def initialize( for_instance, 
                  cascade_type, 
                  configuration_module, 
                  configuration_name, 
                  write_accessor = configuration_name,
                  & block )

    @cascade_type = cascade_type
    @module = configuration_module
    @name = configuration_name.accessor_name
    @write_name = write_accessor.write_accessor_name

    initialize_common( for_instance )

  end
  
  ##################################
  #  self.new_inheriting_instance  #
  ##################################
  
  def self.new_inheriting_instance( for_instance, 
                                    parent_configuration, 
                                    cascade_type = nil, 
                                    include_extend_subclass_instance = nil,
                                    & block )
    
    instance = allocate
    instance.initialize_inheriting_instance( for_instance, 
                                             parent_configuration, 
                                             cascade_type, 
                                             include_extend_subclass_instance,
                                             & block )
    
    return instance
    
  end

  ####################################
  #  initialize_inheriting_instance  #
  ####################################
  
  def initialize_inheriting_instance( for_instance, 
                                      parent_configuration, 
                                      cascade_type = nil, 
                                      include_extend_subclass_instance = nil )
  
    @parent = parent_configuration
    @module = @parent.module
    @name = @parent.name
    @write_name = @parent.write_name
    @cascade_type = cascade_type || @parent.cascade_type
    @include_extend_subclass_instance = include_extend_subclass_instance

    initialize_common( for_instance )
    
    include_extend_subclass_instance ? register_parent_for_ruby_hierarchy( @parent ) : register_parent( @parent )
    
  end
  
  #######################
  #  initialize_common  #
  #######################
  
  def initialize_common( for_instance )

    @instance = for_instance
    @has_value = false
    initialize_for_instance
    
  end
  
  #############################
  #  initialize_for_instance  #
  #############################
  
  ###
  # @private
  #
  # Extends self with appropriate module(s) given instance for which initilization is occuring.
  #
  def initialize_for_instance

    # If we are defining configurations on ::Class we can only have explicit parents.
    case @instance
      
      when ::Class

        extend( self.class::ClassConfiguration )

        if @instance.equal?( ::Class )
          extend( self.class::ClassInstanceConfiguration )
        elsif ( instance_class = @instance.class ) < ::Module and not instance_class < ::Class
          extend( self.class::ClassInheritingFromModuleConfiguration )
        end

      when ::Module

        extend( self.class::ModuleConfiguration )

      else

        extend( self.class::InstanceConfiguration )
      
    end
    
  end

  #################################################
  #  configuration_for_configuration_or_instance  #
  #################################################
  
  def configuration_for_configuration_or_instance( configuration_or_instance )
    
    return case configuration_or_instance
      when ::CascadingConfiguration::Module::Configuration
        configuration_or_instance
      else
        if ::CascadingConfiguration.has_configuration?( configuration_or_instance, @name )
          ::CascadingConfiguration.configuration( configuration_or_instance, @name )
        else
          nil
        end
    end
    
  end

  #####################
  #  register_parent  #
  #####################
  
  ###
  # Register configuration for instance with parent instance as parent for configuration.
  #   Does nothing, serves as placeholder.
  #
  # @param parent
  #
  #        Parent instance from which configurations are being inherited.
  #
  # @return [self]
  #
  #         Self.
  #
  def register_parent( parent )
            
    return self
    
  end

  #######################
  #  unregister_parent  #
  #######################

  ###
  # Remove a current parent for configuration instance.
  #   Does nothing, serves as placeholder.
  #
  # @param existing_parent
  #
  #        Current parent instance to replace.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def unregister_parent( existing_parent )
    
    return self
    
  end
  
  ####################
  #  replace_parent  #
  ####################

  ###
  # Replace a current parent for configuration instance with a different parent.
  #
  # @param existing_parent
  #
  #        Current parent instance to replace.
  #
  # @param new_parent
  #
  #        New parent instance.
  #
  # @return [CascadingConfiguration::Module::Configuration] Self.
  #
  def replace_parent( existing_parent, new_parent )

    unregister_parent( existing_parent )
    register_parent( new_parent )

    return self

  end
  
  ################
  #  is_parent?  #
  ################
  
  def is_parent?( parent )
    
    return false
    
  end
  
  ########################################
  #  register_parent_for_ruby_hierarchy  #
  ########################################
  
  alias_method :register_parent_for_ruby_hierarchy, :register_parent

  ##################
  #  cascade_type  #
  ##################
  
  ###
  # Cascade type for which configuration was created.
  #
  # @!attribute [rw] instance
  #
  # @return [:singleton_and_instance,:singleton,:instance,:local_instance,:object] instance.
  #
  attr_accessor :cascade_type

  ##############
  #  instance  #
  ##############
  
  ###
  # Instance for which configuration exists.
  #
  # @!attribute [r] instance
  #
  # @return [Object] instance.
  #
  attr_reader :instance
  
  ##########
  #  name  #
  ##########
  
  ###
  # Configuration name and read accessor.
  #
  # @!attribute [r] name
  #
  # @return [Symbol,String] configuration name.
  #
  attr_reader :name

  ################
  #  write_name  #
  ################

  ###
  # Configuration write accessor.
  #
  # @!attribute [r] write_name
  #
  # @return [Symbol,String] configuration write name.
  #
  attr_reader :write_name

  ############
  #  module  #
  ############
  
  ###
  # Configuration module for which configuration exists.
  #
  # @!attribute [r] module
  #
  # @return [CascadingConfiguration::Module] Configuration module.
  #
  attr_reader :module

  #######################
  #  extension_modules  #
  #######################

  ###
  # Extension modules associated with configuration.
  #
  # @!attribute [r] extension_modules
  #
  # @return [Array::Unique] Extension modules.
  #
  attr_reader :extension_modules

  ################
  #  has_value?  #
  ################

  ###
  # Query whether instance has a value set for configuration.
  #
  # @return [ true, false ]
  #
  #         Whether configuration name has value for instance.
  #
  def has_value?

    return @has_value

  end
  
  ############
  #  value   #
  ############
  
  ###
  # Get configuration value for configuration name for instance.
  #
  # @return [::Object]
  #
  #         Configuration value.
  #
  def value
    
    return @value

  end

  ############
  #  value=  #
  ############

  ###
  # Set configuration value.
  #
  # @param [ Object ]
  #
  #        object
  #
  #        Value of configuration.
  #
  def value=( object )
    
    @has_value = true
    @value = object
    
  end

  ##################
  #  remove_value  #
  ##################
  
  ###
  # Unset value for configuration.
  #
  # @return Self.
  #
  def remove_value
    
    @has_value = false
    @value = nil
        
    return self

  end

end

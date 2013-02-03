
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
  
  ###
  # @overload new( instance, configuration_module, configuration_name, write_accessor_name = configuration_name )
  #
  # @overload new( instance, parent_configuration )
  #
  def initialize( instance, *args )

    @instance = instance

    case arg_zero = args[ 0 ]
      when self.class
        # we assume all parent instances provided have matching module/name
        @parent = arg_zero
        @module = @parent.module
        @name = @parent.name
        @write_name = @parent.write_name
      else
        @cascade_type = arg_zero
        @module = args[ 1 ]
        @name = args[ 2 ].accessor_name
        @write_name = args[ 3 ] || @name.write_accessor_name
    end

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
        elsif instance_class = @instance.class and
              instance_class < ::Module and not instance_class < ::Class
          extend( self.class::ClassInheritingFromModuleConfiguration )
        end

      when ::Module

        extend( self.class::ModuleConfiguration )

      else

        extend( self.class::InstanceConfiguration )
      
    end
    
  end
  
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

  ##########################
  #  parent_configuration  #
  ##########################
  
  ###
  # Parent configuration instance.
  #
  # @!attribute [r] parent_configuration
  #
  # @return [CascadingConfiguration::Module::Configuration] Parent configuration instance.
  #
  attr_reader :parent_configuration
  
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
    
    @value = nil
    
    @has_value = false
    
    return self

  end

end

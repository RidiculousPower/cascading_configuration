
###
# Configurations that accept a block.
#
class ::CascadingConfiguration::Module::BlockConfigurations < ::CascadingConfiguration::Module

  ###########################
  #  define_configurations  #
  ###########################
  
  ###
  # Define configurations for instance.
  #
  # @overload define_configurations( instance, cascade_type, configuration_name, ... )
  #
  #   @param [ Object ]
  #   
  #          instance
  #   
  #          Instance in which configuration method will be defined.
  #   
  #   @param [ Symbol, String ]
  #   
  #          cascade_type
  #   
  #          Type of method being defined: 
  #   
  #            :all, :module, :class, :instance, :local_instance, :object.
  #
  #   @param [ Symbol, String, Hash{ Symbol, String => Symbol, String } ]
  #
  #          configuration_name
  #
  #          Name of configuration to be defined.
  #
  #   @yield [ ]
  #
  #          Block defining an additional module for extending configuration.
  #
  # @return Self.
  #
  def define_configurations( instance, cascade_type, *names_modules, & block )
    
    if block_given?
      @block = block
    end
    
    super( instance, cascade_type, *names_modules )
    
    return self
    
  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################
  
  #################################
  #  define_configuration_method  #
  #################################

  ###
  # Define a configuration definition method with support for extendable configurations.
  #
  # @param [Symbol,String]
  # 
  #        ccm_method_name
  # 
  #        Name to use for configuration method.
  # 
  # @param [ Symbol, String ]
  # 
  #        cascade_type
  # 
  #        Type of method being defined: 
  #        
  #          :all, :module, :class, :instance, :local_instance, :object.
  #
  # @return Self.
  #
  def define_configuration_method( ccm_method_name, cascade_type )
    
    ccm = self

    #===================#
    #  ccm_method_name  #
    #===================#
    
    define_method( ccm_method_name ) do |*args, & block|

      ccm.define_configurations( self, cascade_type, *args, & block )                  
      
      return self
      
    end

    return self
    
  end

end

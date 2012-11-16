
class ::CascadingConfiguration::Core::Module::ExtendableConfigurations < ::CascadingConfiguration::Core::Module

  #############################
  #  parse_extension_modules  #
  #############################
  
  ###
  # Parse an array of configuration names and/or hash pairs for read/write names.
  #
  # @param [ Array< Symbol, String, Hash{ Symbol, String => Symbol, String } > ]
  #
  #        names_modules
  #
  #        Configuration name descriptors. 
  #        Symbols and Strings are read/write.
  #        Hash pairs are read => write.
  #
  # @return [ Hash{ Symbol => Symbol  } ]
  #
  def parse_extension_modules( names_modules )
    
    # We can have configuration names or modules - we need to separate them.
    names = [ ]
    modules = [ ]

    names_modules.each do |this_name_or_module|

      case this_name_or_module
        
        when ::Class

          raise ArgumentError, 'Module expected (received Class).'
        
        when ::Module

          modules.push( this_name_or_module )

        else
        
          names.push( this_name_or_module )
        
      end
      
    end
    
    names_modules_hash = { }
    
    # if we have a block to define extensions to the compositing object:
      
    names.each do |this_name|
      names_modules_hash[ this_name ] = modules
    end
    
    return names_modules_hash
    
  end

  #################################
  #  define_configuration_method  #
  #################################

  ###
  # Define a configuration definition method with support for extendable configurations.
  #
  # @param [ Symbol, String ]
  # 
  #        ccm_method_name
  # 
  #        Name to use for configuration method.
  # 
  # @param [ Array< Symbol, String > ]
  # 
  #        method_types
  # 
  #        Type of method being defined: 
  #        
  #          :all, :module, :class, :instance, :local_instance, :object.
  #
  # @return Self.
  #
  def define_configuration_method( ccm_method_name, method_types )
    
    ccm = self
     
    #===================#
    #  ccm_method_name  #
    #===================#
    
    define_method( ccm_method_name ) do |*args, & definer_block|
      
      ccm.define_configurations( self, method_types, *args, & definer_block )                  
      
      return self
      
    end

    return self
    
  end

  ###########################
  #  define_configurations  #
  ###########################
  
  ###
  # Define configurations for instance.
  #
  # @overload define_configurations( instance, method_types, configuration_name, ... )
  #
  #   @param [ Object ]
  #   
  #          instance
  #   
  #          Instance in which configuration method will be defined.
  #   
  #   @param [ Array< Symbol, String > ]
  #   
  #          method_types
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
  def define_configurations( instance_controller, method_types, *names_modules, & definer_block )
    
    block_defined_module = nil
    
    if block_given?
      block_defined_module = instance_controller.class::ExtensionModule.new( self, name, & definer_block )
      constant_name = name.to_s.to_camel_case
      const_set( constant_name, block_defined_module )
    end
    
    # Ask MethodModule to parse extension modules for these declarations on instance.
    names_modules_hash = parse_extension_modules( names_modules )
    
    instance = instance_controller.instance
    
    names_modules_hash.each do |this_configuration_name, these_modules|
      this_configuration = ::CascadingConfiguration.configuration( instance, this_configuration_name )
      if block_defined_module
        these_modules.push( block_defined_module )
      end
      this_configuration.extension_modules.unshift( *these_modules.reverse )
    end
    
    names = names_modules_hash.keys

    super( instance_controller, method_types, *names )
    
  end

end

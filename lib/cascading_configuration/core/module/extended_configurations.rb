
class ::CascadingConfiguration::Core::Module::ExtendedConfigurations < ::CascadingConfiguration::Core::Module

  ##################################
  #  self.parse_extension_modules  #
  ##################################
  
  def self.parse_extension_modules( instance_controller, encapsulation, *names_modules )
    
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

  ###########################
  #  define_configurations  #
  ###########################
  
  def define_configurations( instance_controller, encapsulation, method_types, *names_modules, & definer_block )
    
    # Ask MethodModule to parse extension modules for these declarations on instance.
    names_modules_hash = self.class.parse_extension_modules( instance_controller, encapsulation, *names_modules )
    
    names_modules_hash.each do |this_name, these_modules|
      instance_controller.add_extension_modules( this_name, encapsulation, *these_modules, & definer_block )
    end
    
    names = names_modules_hash.keys

    super( instance_controller, encapsulation, method_types, *names, & definer_block )
    
  end

end

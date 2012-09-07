
class ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects < 
      ::CascadingConfiguration::Core::Module::ExtendedConfigurations
  
  ################
  #  initialize  #
  ################
  
  def initialize( ccm_name, 
                  compositing_object_class = nil,
                  default_encapsulation_or_encapsulation_name = ::CascadingConfiguration::Core::
                                                                  Module::DefaultEncapsulation, 
                  *ccm_aliases )
    
    super( ccm_name, default_encapsulation_or_encapsulation_name, *ccm_aliases )
    
    @compositing_object_class = compositing_object_class
    
  end

  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  def permits_multiple_parents?
    
    return true
    
  end

  ##########################
  #  create_configuration  #
  ##########################

  def create_configuration( encapsulation, instance, name )
    
    unless compositing_object = encapsulation.get_configuration( instance, name )
    
      super

      # initialize without initializing for parents
      # we will initialize for parents after initializing all instances for inheritance
      compositing_object = @compositing_object_class.new( nil, instance )

      instance_controller = ::CascadingConfiguration::Core::
                              InstanceController.nearest_instance_controller( encapsulation, instance, name )
  
      if instance_controller
      
        extension_modules = instance_controller.extension_modules_upward( name, encapsulation )
    
        unless extension_modules.empty?
          # Modules are gathered from lowest ancestor upward. This means that they are already 
          # in the proper order for include/extend (which usually we would have to reverse).
          compositing_object.extend( *extension_modules )
        end
    
      end
        
      encapsulation.set_configuration( instance, name, compositing_object )    
    
    end
    
    return compositing_object
    
  end

  ##############################
  #  initialize_configuration  #
  ##############################
  
  def initialize_configuration( encapsulation, instance, name )
    
    initialize_compositing_configuration_for_parent( encapsulation, instance, name )
    
  end

  ##############################
  #  compositing_object_class  #
  ##############################
  
  attr_reader :compositing_object_class

  ############
  #  setter  #
  ############
  
  def setter( encapsulation, instance, name, value )
    
    compositing_object = encapsulation.get_configuration( instance, name )

    compositing_object.replace( value )

    return compositing_object
    
  end
  
  #####################
  #  instance_setter  #
  #####################
  
  def instance_setter( encapsulation, instance, name, value )
    
    # ensure our compositing object already exists
    instance_getter( encapsulation, instance, name )
    
    # now we can set normally
    return setter( encapsulation, instance, name, value )
    
  end
  
  ############
  #  getter  #
  ############

  def getter( encapsulation, instance, name )
        
    return encapsulation.get_configuration( instance, name )
    
  end

  #####################
  #  instance_getter  #
  #####################
  
  def instance_getter( encapsulation, instance, name )
    
    compositing_object = nil

    unless compositing_object = encapsulation.get_configuration( instance, name )
      compositing_object = initialize_compositing_configuration_for_parent( encapsulation, instance, name )
    end

    return compositing_object
    
  end

  #####################################################
  #  initialize_compositing_configuration_for_parent  #
  #####################################################
  
  def initialize_compositing_configuration_for_parent( encapsulation, instance, configuration_name )

    unless compositing_object = encapsulation.get_configuration( instance, configuration_name )
      compositing_object = create_configuration( encapsulation, instance, configuration_name )
    end
    
    # if instance has a parent
    if parent = encapsulation.parent_for_configuration( instance, configuration_name )

      # We are initializing for existing ancestors, but they may not have initialized yet - 
      # so we need to make sure they did before we initialize for instance.
      
      # As long as our ancestor has an ancestor make sure that it has initialized for its parent.
      # We can break at the first ancestor that we hit that has initialized for parent
      # or if we run out of ancestors.

      parent_composite_object = encapsulation.get_configuration( parent, configuration_name )
      parent_composite_object2 = nil
      if parent2 = encapsulation.parent_for_configuration( parent, configuration_name )
        parent_composite_object2 = encapsulation.get_configuration( parent2, configuration_name )
      end
      
      # if first parent for configuration isn't initialized yet, initialize it
      unless parent_composite_object and
             parent_composite_object.has_parent?( parent_composite_object2 )

        parent_composite_object = initialize_compositing_configuration_for_parent( encapsulation, 
                                                                                   parent, 
                                                                                   configuration_name )
      end

      unless compositing_object.has_parent?( parent_composite_object )
        compositing_object.register_parent( parent_composite_object )
      end
      
    end

    return compositing_object
  
  end

end

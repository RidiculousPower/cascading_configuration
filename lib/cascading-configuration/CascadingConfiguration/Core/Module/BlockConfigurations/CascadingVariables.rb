
class ::CascadingConfiguration::Core::Module::BlockConfigurations::CascadingVariables < 
      ::CascadingConfiguration::Core::Module::BlockConfigurations

  ##########################
  #  create_configuration  #
  ##########################

  # Pending.
  def create_configuration( encapsulation, instance, name )

    super

    # initialize without initializing for parents
    # we will initialize for parents after initializing all instances for inheritance
    compositing_object = @compositing_object_class.new( nil, instance )

    instance_controller = ::CascadingConfiguration::Core::InstanceController.nearest_instance_controller( encapsulation, 
                                                                                                    instance, 
                                                                                                    name )

    extension_modules = instance_controller.extension_modules_upward( name, encapsulation )
    
    unless extension_modules.empty?
      # Modules are gathered from lowest ancestor upward. This means that they are already 
      # in the proper order for include/extend (which usually we would have to reverse).
      compositing_object.extend( *extension_modules )
    end
    
    encapsulation.set_configuration( instance, name, compositing_object )    
    
    initialize_compositing_configuration_for_parent( encapsulation, instance, name )
    
    return compositing_object
    
  end

  ############
  #  setter  #
  ############

  # Pending.
  def setter( encapsulation, instance, name, value )

    return encapsulation.set_configuration( instance, name, value )

  end

  ############
  #  getter  #
  ############

  # Pending.
  def getter( encapsulation, instance, name )

    return encapsulation.get_configuration( instance, name )

  end

  #####################
  #  instance_setter  #
  #####################

  # Pending.
  def instance_setter( encapsulation, instance, name, value )

    # ensure our compositing object already exists
    instance_getter( encapsulation, instance, name, value )

    # now we can set normally
    return setter( encapsulation, instance, name, value )

  end

  #####################
  #  instance_getter  #
  #####################

  # Pending.
  def instance_getter( encapsulation, instance, name )

    cascading_value = nil
    
    if encapsulation.has_configuration_value?( instance, name )
      cascading_value = encapsulation.get_configuration( instance, name )
    else
      cascading_value = initialize_configuration_for_parent( encapsulation, instance, configuration_name )
    end

    return cascading_value

  end

  #####################################################
  #  initialize_compositing_configuration_for_parent  #
  #####################################################
  
  # Pending.
  def initialize_compositing_configuration_for_parent( encapsulation, instance, configuration_name )

    unless compositing_object = encapsulation.get_configuration( instance, configuration_name )
      compositing_object = create_configuration( encapsulation, instance, configuration_name )
    end
    
    # if instance has a parent
    if parent = encapsulation.parent_for_configuration( instance, configuration_name )

      # if first parent for configuration isn't initialized yet, initialize it
      unless parent_composite_object = encapsulation.get_configuration( parent, configuration_name )
        parent_composite_object = initialize_compositing_configuration_for_parent( encapsulation, 
                                                                                   parent, 
                                                                                   configuration_name )
      end
      
      unless compositing_object.parent_composite_object == parent_composite_object
        compositing_object.initialize_for_parent( parent_composite_object )
      end
      
    end

    return compositing_object
  
  end

end

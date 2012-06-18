
module ::CascadingConfiguration::Core::InstanceController::Methods::LocalInstanceMethods

  ##################################
  #  define_local_instance_method  #
  ##################################

  def define_local_instance_method( name, 
                                    encapsulation_or_name = ::CascadingConfiguration::Core::
                                                              Module::DefaultEncapsulation, 
                                    & method_proc )

    return create_local_instance_support( encapsulation_or_name ).define_method( name, & method_proc )

  end

  #################################
  #  alias_local_instance_method  #
  #################################
  
  def alias_local_instance_method( alias_name, 
                                   name, 
                                   encapsulation_or_name = ::CascadingConfiguration::Core::
                                                             Module::DefaultEncapsulation )

    aliased_method = false
    
    if local_instance_support = local_instance_support( encapsulation_or_name )
      aliased_method = local_instance_support.alias_method( alias_name, name, encapsulation_or_name )
    end
    
    return aliased_method

  end
  
  ##################################
  #  remove_local_instance_method  #
  ##################################

  def remove_local_instance_method( name, 
                                    encapsulation_or_name = ::CascadingConfiguration::Core::
                                                              Module::DefaultEncapsulation )

    removed_method = false

    if local_instance_support = local_instance_support( encapsulation_or_name )
      removed_method = local_instance_support.remove_method( name )
    end
    
    return removed_method
    
  end
  
  #################################
  #  undef_local_instance_method  #
  #################################

  def undef_local_instance_method( name, 
                                   encapsulation_or_name = ::CascadingConfiguration::Core::
                                                             Module::DefaultEncapsulation )

    undefined_method = false

    if local_instance_support = local_instance_support( encapsulation_or_name )
      undefined_method = local_instance_support.undef_method( name )
    end
    
    return undefined_method
    
  end

end

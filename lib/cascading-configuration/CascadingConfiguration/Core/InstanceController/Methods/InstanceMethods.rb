
module ::CascadingConfiguration::Core::InstanceController::Methods::InstanceMethods

  ############################
  #  define_instance_method  #
  ############################

  def define_instance_method( name, 
                              encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                              & method_proc )

    return create_instance_support( encapsulation_or_name ).define_method( name, & method_proc )
    
  end

  ############################
  #  remove_instance_method  #
  ############################

  def remove_instance_method( name, 
                              encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    removed_method = false

    if instance_support = instance_support( encapsulation_or_name )
      removed_method = instance_support.remove_method( name )
    end
    
    return removed_method
    
  end

  ###########################
  #  undef_instance_method  #
  ###########################

  def undef_instance_method( name, 
                             encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    undefined_method = false

    if instance_support = instance_support( encapsulation_or_name )
      undefined_method = instance_support.undef_method( name )
    end
    
    return undefined_method
    
  end

  #######################################
  #  define_instance_method_if_support  #
  #######################################
  
  def define_instance_method_if_support( name, 
                                         encapsulation_or_name = ::CascadingConfiguration::Core::
                                                                   Module::DefaultEncapsulation, 
                                         & method_proc )

    if instance_support = instance_support( encapsulation_or_name )
      instance_support.define_method( name, & method_proc )
    end 
    
    return self
    
  end
  
  ###########################
  #  alias_instance_method  #
  ###########################
  
  def alias_instance_method( encapsulation_or_name, alias_name, name )

    aliased_method = false
    
    if instance_support = instance_support( encapsulation_or_name )
      aliased_method = instance_support.alias_method( alias_name, name )
    end
    
    return aliased_method

  end
  
end

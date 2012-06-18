
module ::CascadingConfiguration::Core::InstanceController::Methods::SingletonMethods

  #############################
  #  define_singleton_method  #
  #############################

  def define_singleton_method( name, 
                               encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation, 
                               & method_proc )

    return create_singleton_support( encapsulation_or_name ).define_method( name, & method_proc )

  end 

  #########################
  #  alias_module_method  #
  #########################
  
  def alias_module_method( alias_name, 
                           name, 
                           encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    aliased_method = false
    
    if singleton_support = singleton_support( encapsulation_or_name )
      aliased_method = singleton_support.alias_method( alias_name, name )
    end
    
    return aliased_method

  end

  ##########################
  #  remove_module_method  #
  ##########################

  def remove_module_method( name, encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    removed_method = false

    if singleton_support = singleton_support( encapsulation_or_name )
      removed_method = singleton_support.remove_method( name )
    end
    
    return removed_method
    
  end

  #########################
  #  undef_module_method  #
  #########################

  def undef_module_method( name, encapsulation_or_name = ::CascadingConfiguration::Core::Module::DefaultEncapsulation )

    undefined_method = false

    if singleton_support = singleton_support( encapsulation_or_name )
      undefined_method = singleton_support.undef_method( name )
    end
    
    return undefined_method
    
  end
  
end

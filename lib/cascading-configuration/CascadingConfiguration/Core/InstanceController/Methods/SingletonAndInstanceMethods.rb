
module ::CascadingConfiguration::Core::InstanceController::Methods::SingletonAndInstanceMethods

  ###########################################
  #  define_singleton_and_instance_methods  #
  ###########################################

  def define_singleton_and_instance_methods( name, encapsulation_or_name, & method_proc )

    define_singleton_method( name, encapsulation_or_name, & method_proc )
    define_instance_method( name, encapsulation_or_name, & method_proc )

  end

  ############################################################
  #  define_singleton_method_and_instance_method_if_support  #
  ############################################################

  def define_singleton_method_and_instance_method_if_support( name, encapsulation_or_name, & method_proc )

    define_singleton_method( name, encapsulation_or_name, & method_proc )
    define_instance_method_if_support( name, encapsulation_or_name, & method_proc )

  end

  #######################################
  #  alias_module_and_instance_methods  #
  #######################################
  
  def alias_module_and_instance_methods( encapsulation_or_name, alias_name, name )
    
    alias_module_method( encapsulation_or_name, alias_name, name )
    alias_instance_method( encapsulation_or_name, alias_name, name )
    
  end
  
end


class ::CascadingConfiguration::Core::Module::InheritingValues < ::CascadingConfiguration::Core::Module
  
  ############
  #  setter  #
  ############
  
  def setter( encapsulation, instance, name, value )
    
    return encapsulation.set_configuration( instance, name, value )
    
  end
  
  ############
  #  getter  #
  ############

  def getter( encapsulation, instance, name )
    
    return get_configuration_searching_upward( encapsulation, instance, name )
    
  end

  #####################
  #  instance_getter  #
  #####################

  alias_method( :instance_getter, :getter )

  #####################
  #  instance_setter  #
  #####################
  
  alias_method( :instance_setter, :setter )

  ########################################
  #  get_configuration_searching_upward  #
  ########################################

  def get_configuration_searching_upward( encapsulation, instance, configuration_name )

    configuration_value = nil

    matching_ancestor = nil

    matching_ancestor = encapsulation.match_parent( instance, configuration_name ) do |this_ancestor|
      if encapsulation.has_configuration_value?( this_ancestor, configuration_name )
        true
      else
        false
      end
    end

    if matching_ancestor
      configuration_value = encapsulation.get_configuration( matching_ancestor, configuration_name )
    end
    
    return configuration_value
    
  end
  
end

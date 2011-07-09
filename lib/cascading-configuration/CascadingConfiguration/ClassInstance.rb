
module CascadingConfiguration::ClassInstance

	########################################
  #  get_configuration_searching_upward  #
  ########################################

  def get_configuration_searching_upward( configuration_name )

		configuration = nil

    configuration_variable_name = configuration_variable_name( configuration_name )

    # search upward for first explicitly set value
    ancestors.each do |this_ancestor|
      if this_ancestor.instance_variable_defined?( configuration_variable_name )
        configuration = this_ancestor.instance_variable_get( configuration_variable_name )
        break
      end
    end

    return configuration

	end
  
  ##############################################
  #  get_cascading_array_downward_from_Object  #
  ##############################################

  def get_cascading_array_downward_from_Object( configuration_name )
		
		return get_cascading_configuration_downward_from_Object( configuration_name, ::CascadingConfiguration::CascadingCompositeArray )

	end

  #############################################
  #  get_cascading_hash_downward_from_Object  #
  #############################################

  def get_cascading_hash_downward_from_Object( configuration_name )
		
		return get_cascading_configuration_downward_from_Object( configuration_name, ::CascadingConfiguration::CascadingCompositeHash )

	end
	
end

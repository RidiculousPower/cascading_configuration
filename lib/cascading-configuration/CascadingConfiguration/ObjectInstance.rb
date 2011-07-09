
module CascadingConfiguration::ObjectInstance
		
  ########################################
  #  get_configuration_searching_upward  #
  ########################################

  def get_configuration_searching_upward( configuration_name )

		configuration = nil

    configuration_variable = configuration_variable_name( configuration_name )

    if instance_variable_defined?( configuration_variable )
			# if our instance defines this configuration, use its setting
      configuration = instance_variable_get( configuration_variable )
    else
			# otherwise, search upward to find the first ancestor with a setting for this configuration
      configuration = self.class.get_configuration_searching_upward( configuration_name )
    end
    
    return configuration

  end

  ##############################################
  #  get_cascading_array_downward_from_Object  #
  ##############################################

  def get_cascading_array_downward_from_Object( configuration_name )

    configuration_variable = configuration_variable_name( configuration_name )

    configuration = self.class.get_cascading_array_downward_from_Object( configuration_name )

		if instance_variable_defined?( configuration_variable )
	    configuration = configuration.concat( instance_variable_get( configuration_variable ) ).sort.uniq
		end

    # return configuration
    return configuration

  end

  #############################################
  #  get_cascading_hash_downward_from_Object  #
  #############################################

  def get_cascading_hash_downward_from_Object( configuration_name )

    configuration_variable = configuration_variable_name( configuration_name )

    configuration = self.class.get_cascading_hash_downward_from_Object( configuration_name )
    
		if instance_variable_defined?( configuration_variable )
			this_configuration_element = instance_variable_get( configuration_variable )
			configuration.instance_eval { update_adding_composite_elements( this_configuration_element ) }
		end

		# record where configuration changes will be made
		configuration.working_instance = self

    # return configuration
    return configuration

  end

	###########################
	#  local_cascading_array  #
	###########################
	
	def local_cascading_array( configuration_name )
		
		local_cascading_array_instance = nil
		
		configuration_variable_name = configuration_variable_name( configuration_name )
    
		if instance_variable_defined?( configuration_variable_name )
			local_cascading_array_instance = instance_variable_get( configuration_variable_name )
		else
			local_cascading_array_instance = Array.new
			local_cascading_array_instance.extend( ::CascadingConfiguration::ConfigurationArray )
			instance_variable_set( configuration_variable_name, local_cascading_array_instance )
		end
		
		return local_cascading_array_instance

	end

	##########################
	#  local_cascading_hash  #
	##########################
	
	def local_cascading_hash( configuration_name )
		
		local_cascading_hash_instance = nil
		
		configuration_variable_name = configuration_variable_name( configuration_name )
    
		if instance_variable_defined?( configuration_variable_name )
			local_cascading_hash_instance = instance_variable_get( configuration_variable_name )
		else
			local_cascading_hash_instance = Hash.new
			local_cascading_hash_instance.extend( ::CascadingConfiguration::ConfigurationHash )
			instance_variable_set( configuration_variable_name, local_cascading_hash_instance )
		end
		
		return local_cascading_hash_instance

	end
	
end

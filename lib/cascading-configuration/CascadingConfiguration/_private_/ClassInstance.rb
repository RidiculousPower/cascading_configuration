
module CascadingConfiguration::ClassInstance

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

	################
	#  eigenclass  #
	################

	def eigenclass
		return class << self ; self ; end
	end

	######################################################
	#  get_cascading_configuration_downward_from_Object  #
	######################################################

	def get_cascading_configuration_downward_from_Object( configuration_name, composite_configuration_class )

    # merge downward from Object, including overrides from each subclass
		ancestors_from_object = ancestors
    if index = ancestors_from_object.index( Object )
      ancestors_from_object.slice!( index, ancestors_from_object.count )
    end
    
    ancestors_from_object.reverse!
    
    configuration_variable_name = configuration_variable_name( configuration_name )

		# we use a composite class to control cascading configurations
		configuration = composite_configuration_class.new

    ancestors_from_object.each do |this_ancestor|
			# if this ancestor doesn't have a configuration variable we can skip this ancestor
			if this_ancestor.instance_variable_defined?( configuration_variable_name )
				this_configuration_element = this_ancestor.instance_variable_get( configuration_variable_name )
				# cascade this configuration
				# our composite class will keep a reference to the configuration (so it can be changed)
				# and will overtly appear to be the composite element
				configuration.instance_eval { update_adding_composite_elements( this_configuration_element ) }
			end
    end

		# record where configuration changes will be made
		configuration.working_instance = self
    
    return configuration

	end

end

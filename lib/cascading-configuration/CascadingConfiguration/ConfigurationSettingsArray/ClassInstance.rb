
module CascadingConfiguration::ConfigurationSettingsArray::ClassInstance

	##############################
	#  attr_configuration_array  #
	##############################

	def attr_configuration_array( *property_names )
		property_names.each do |this_property_name|
			# define configuration setter
			CascadingConfiguration::ConfigurationSettingsArray.define_configuration_setter( self, this_property_name )
			# define configuration getter
			CascadingConfiguration::ConfigurationSettingsArray.define_configuration_getter( self, this_property_name )
		end
	end

end

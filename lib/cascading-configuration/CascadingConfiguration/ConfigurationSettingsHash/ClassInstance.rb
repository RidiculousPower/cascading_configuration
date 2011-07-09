
module CascadingConfiguration::ConfigurationSettingsHash::ClassInstance

	#############################
	#  attr_configuration_hash  #
	#############################

	def attr_configuration_hash( *property_names )
		property_names.each do |this_property_name|
			# define configuration setter
			CascadingConfiguration::ConfigurationSettingsHash.define_configuration_setter( self, this_property_name )
			# define configuration getter
			CascadingConfiguration::ConfigurationSettingsHash.define_configuration_getter( self, this_property_name )
		end
	end

end

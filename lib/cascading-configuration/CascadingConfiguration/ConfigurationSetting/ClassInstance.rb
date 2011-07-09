
module CascadingConfiguration::ConfigurationSetting::ClassInstance

	################################
	#  attr_configuration_setting  #
	################################

	def attr_configuration_setting( *property_names )
		property_names.each do |this_property_name|
			# define configuration setter
			CascadingConfiguration::ConfigurationSetting.define_configuration_setter( self, this_property_name )
			# define configuration getter
			CascadingConfiguration::ConfigurationSetting.define_configuration_getter( self, this_property_name )
		end
	end

end

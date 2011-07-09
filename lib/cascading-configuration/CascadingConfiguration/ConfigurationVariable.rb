
module CascadingConfiguration::ConfigurationVariable
	
	###################
	#  self.included  #
	###################

	def self.included( klass_or_module_instance )
		klass_or_module_instance.instance_eval do
			extend  CascadingConfiguration::ConfigurationVariable
			extend  CascadingConfiguration::ConfigurationVariable::ClassInstance
			include CascadingConfiguration::ConfigurationVariable::ObjectInstance
		end
	end

	################################
	#  attr_configuration_prefix=  #
	################################
	
	def attr_configuration_prefix=( prefix )
		@attr_configuration_prefix = prefix
	end

	#################################
	#  configuration_variable_name  #
	#################################
	
	def configuration_variable_name( configuration_name )
		return ( '@' + attr_configuration_prefix.to_s + configuration_name.to_s ).to_sym
	end
	
end

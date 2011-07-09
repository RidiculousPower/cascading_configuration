
module CascadingConfiguration::ConfigurationSettingsArray
	
	###################
	#  self.included  #
	###################

	def self.included( klass_or_module_instance )
		klass_or_module_instance.instance_eval do
			include CascadingConfiguration::ConfigurationVariable
			extend  CascadingConfiguration::ConfigurationSettingsArray::ClassInstance
		end
	end

	###################
	#  self.excluded  #
	###################

	def self.excluded( klass_or_module_instance )
		klass_or_module_instance.instance_eval do
			extend CascadingConfiguration::ConfigurationVariable
		end
	end

end

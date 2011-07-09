
module CascadingConfiguration::ConfigurationVariable::ObjectInstance

	###############################
	#  attr_configuration_prefix  #
	###############################
	
	def attr_configuration_prefix( *args )

		prefix = nil

		if args.count > 0
			
			prefix = @attr_configuration_prefix = args[ 0 ]
			
		else

			if instance_variable_defined?( :@attr_configuration_prefix )
				prefix = @attr_configuration_prefix
			else
				prefix = self.class.attr_configuration_prefix
			end

		end

		return prefix

	end

end

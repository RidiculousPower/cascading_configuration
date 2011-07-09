
module CascadingConfiguration::ConfigurationVariable::ClassInstance
	
	###############################
	#  attr_configuration_prefix  #
	###############################
	
	def attr_configuration_prefix( *args )

		prefix = nil

		if args.count > 0
			
			prefix = @attr_configuration_prefix = args[ 0 ]
			
		else

			[ self ].concat( ancestors ).each do |this_ancestor|
				if this_ancestor.instance_variable_defined?( :@attr_configuration_prefix )
					prefix = this_ancestor.instance_variable_get( :@attr_configuration_prefix )
					break
				end
			end

		end
		
		return prefix
	end

end

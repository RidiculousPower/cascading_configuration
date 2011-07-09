
module CascadingConfiguration::CascadingComposite

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

	#######################
	#  working_instance=  #
	#######################

	def working_instance=( klass_or_instance )
		@working_instance = klass_or_instance
	end

	######################
	#  working_instance  #
	######################

	def working_instance
		return @working_instance
	end

end

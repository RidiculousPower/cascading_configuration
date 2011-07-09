
module CascadingConfiguration::ConfigurationSet

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

	##########################
	#  add_to_exclude_array  #
	##########################

	def add_to_exclude_array( *elements )
		@exclude_array ||= Array.new
		@exclude_array += elements
		@exclude_array.sort.uniq!
	end

	###############################
	#  remove_from_exclude_array  #
	###############################

	def remove_from_exclude_array( *elements )
		if @exclude_array
			@exclude_array -= elements
			@exclude_array.sort.uniq!
		else
			@exclude_array ||= Array.new
		end
	end
	
end

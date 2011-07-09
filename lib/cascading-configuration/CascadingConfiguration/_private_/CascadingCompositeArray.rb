
module CascadingConfiguration::CascadingCompositeArray
	
  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

	######################################
	#  update_adding_composite_elements  #
	######################################

	def update_adding_composite_elements( *elements_to_cascade )
		push( *elements_to_cascade )
	end

	########################################
	#  update_removing_composite_elements  #
	########################################

	def update_removing_composite_elements( *elements_to_exclude )
		delete_if { |element| elements_to_exclude.include?( element ) }
	end

end

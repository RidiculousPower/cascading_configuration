
module CascadingConfiguration::CascadingCompositeHash
	
	######################################
	#  update_adding_composite_elements  #
	######################################

	def update_adding_composite_elements( *elements_to_cascade )
		merge!( *elements_to_cascade )
	end

end

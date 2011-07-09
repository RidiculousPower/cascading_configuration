
module CascadingConfiguration::CascadingComposite
	
	###############################
	#  cascade_composite_element  #
	###############################
	
	def cascade_composite_element( *elements )
		# update self for cascade
		update_adding_composite_elements( *elements )
	end
	

end

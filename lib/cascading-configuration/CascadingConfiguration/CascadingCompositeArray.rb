
module CascadingConfiguration::CascadingCompositeArray
	
	include CascadingConfiguration::CascadingComposite
		
	#########
	#  []=  #
	#########

	def []=( index, element )
		# we sort internally, so index is irrelevant
		# no reason to differentiate from push
		push( element )
	end

	########
	#  <<  #
	########
	
	def <<( *elements )
		# no reason to differentiate from push
		push( elements )
	end
	
	#######
	#  +  #
	#######

	def +( *elements )
		# no reason to differentiate from push
		push( elements )
	end
	
	##########
	#  push  #
	##########
	
	def push( *elements )

		# we are a composite array
		# that means we have to set the value for our class
		class_or_instance_for_this_cascading_element.local_cascading_array( configuration_name ).push( *elements )
		
		update_adding_composite_elements( elements )
		
		return self

	end
	
	#######
	#  -  #
	#######
	
	def -( *elements )
		
		local_cascading_array = class_or_instance_for_this_cascading_element.local_cascading_array( configuration_name )
		local_cascading_array -= elements

		update_removing_composite_elements( elements )
		
	end

	#########
	#  pop  #
	#########
	
	def pop

		element = super

		local_cascading_array = class_or_instance_for_this_cascading_element.local_cascading_array( configuration_name )
		local_cascading_array -= element

		return element

	end

	###########
	#  shift  #
	###########
	
	def shift

		element = super

		local_cascading_array = class_or_instance_for_this_cascading_element.local_cascading_array( configuration_name )
		local_cascading_array -= element

		return element
		
	end

	############
	#  slice!  #
	############
	
	def slice!( *args )

		elements = super

		local_cascading_array = class_or_instance_for_this_cascading_element.local_cascading_array( configuration_name )
		local_cascading_array -= elements
		
		return elements
		
	end
	
	###########
	#  clear  #
	###########
	
	def clear

		# add all existing values to exclude array
		local_cascading_array = class_or_instance_for_this_cascading_element.local_cascading_array( configuration_name )
		local_cascading_array -= self

		# clear existing values
		super

	end
	
end

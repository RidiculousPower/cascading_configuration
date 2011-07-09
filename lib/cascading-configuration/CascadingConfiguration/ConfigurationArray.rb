
module CascadingConfiguration::ConfigurationArray

	include CascadingConfiguration::ConfigurationSet

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
		
		configuration_variable_name = configuration_variable_name( configuration_name )

		# add elements to configuration array
		push( elements )
		
		# sort and uniq self
		sort.uniq!
		
		# make sure we don't still have any elements noted as excluded at this level
		remove_from_exclude_array( elements )

		return self
		
	end
	
	#######
	#  -  #
	#######
	
	def -( *elements )
		
		delete_if { |this_element| elements.include?( this_element ) }
		
		# add subtracted elements to exclude array
		add_to_exclude_array( elements )
		
		return self
	
	end

	#########
	#  pop  #
	#########
	
	def pop
		
		element = super
		
		# add popped element to exclude array
		add_to_exclude_array( element )
		
		return element
	
	end

	###########
	#  shift  #
	###########
	
	def shift

		element = super

		# add shifted element to exclude array
		add_to_exclude_array( element )

		return element

	end

	############
	#  slice!  #
	############
	
	def slice!( *args )

		elements = super

		# add sliced elements to exclude array
		add_to_exclude_array( elements )

		return elements

	end
	
	###########
	#  clear  #
	###########
	
	def clear

		# add all existing values to exclude array
		add_to_exclude_array( self )

		# clear existing values
		super

	end

end

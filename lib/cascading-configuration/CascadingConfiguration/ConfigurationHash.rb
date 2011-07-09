
module CascadingConfiguration::ConfigurationHash

	include CascadingConfiguration::ConfigurationSet

	#########
	#  []=  #
	#########

	def []=( key, value )
		super
		remove_from_exclude_array( key )		
	end
	alias_method :store, :[]=

	############
	#  merge!  #
	############
	
	def merge!( other_hash )
		super
		remove_from_exclude_array( *other_hash.keys )
		return self
	end
	
	#############
	#  replace  #
	#############
	
	def replace( other_hash )
		add_to_exclude_array( self.keys )
		super
	end

	###########
	#  shift  #
	###########
	
	def shift
		element = super
		add_to_exclude_array( element )
		return element
	end

end

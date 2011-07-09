
module CascadingConfiguration::CascadingCompositeHash

	include CascadingConfiguration::CascadingComposite

	#########
	#  []=  #
	#########

	def []=( key, value )
		class_or_instance_for_this_cascading_element.local_cascading_hash( configuration_name )[ key ] = value
	end
	alias_method :store, :[]=

	############
	#  merge!  #
	############
	
	def merge!( other_hash )
		class_or_instance_for_this_cascading_element.local_cascading_hash( configuration_name ).merge!( other_hash )
		return self
	end
	
	#############
	#  replace  #
	#############
	
	def replace( other_hash )
		# clear any existing settings
		class_or_instance_for_this_cascading_element.local_cascading_hash( configuration_name ).clear
		# merge replacement settings
		class_or_instance_for_this_cascading_element.local_cascading_hash( configuration_name ).merge( other_hash )
		return self
	end

	###########
	#  shift  #
	###########
	
	def shift
		element = super
		local_cascading_hash = class_or_instance_for_this_cascading_element.local_cascading_hash( configuration_name )
		local_cascading_hash -= element
		return self
	end

end

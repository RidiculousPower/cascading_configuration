
module CascadingConfiguration::ClassInstance::Accessors
	
	#################################
	#  define_configuration_setter  #
	#################################
	
	def define_configuration_setter( configuration_name )
		configuration_setter_name = ( configuration_name.to_s + '=' ).to_s
		[ self, eigenclass ].each do |klass_or_eigenclass|
			klass_or_eigenclass.class_eval do
				define_method( configuration_setter_name ) do |value|
					# configuration setter returns setting variable (variable from self), which is now the ID of value
					return instance_variable_set( configuration_variable_name( configuration_name ), value )
				end
			end
		end
	end

	#################################
	#  define_configuration_getter  #
	#################################
	
	def define_configuration_getter( configuration_name )
		configuration_getter_name = configuration_name
		define_method( configuration_getter_name ) do
			# configuration getter returns current setting value (taken from first superclass with setting)
			# that means first variable that has been set
			return get_configuration_searching_upward( configuration_name )
		end
		eigenclass.class_eval do
			define_method( configuration_getter_name ) do
				# configuration getter returns current setting value (taken from first superclass with setting)
				# that means first variable that has been set
				return get_configuration_searching_upward( configuration_name )
			end
		end
	end

	#######################################
	#  define_configuration_array_setter  #
	#######################################
	
	def define_configuration_array_setter( configuration_name )
		[ self, eigenclass ].each do |klass_or_eigenclass|
			klass_or_eigenclass.class_eval do
				configuration_setter_name = ( configuration_name.to_s + '=' ).to_sym
				define_method( configuration_setter_name ) do |value|
					# configuration setting array returns array variable (variable from self)
					instance_variable_set( configuration_variable_name( configuration_name ), value )
					return value
				end
			end
		end
	end

	#######################################
	#  define_configuration_array_getter  #
	#######################################
	
	def define_configuration_array_getter( configuration_name )
		configuration_getter_name = configuration_name
		define_method( configuration_getter_name ) do
			return get_cascading_array_downward_from_Object( configuration_name )
		end
		eigenclass.class_eval do
			define_method( configuration_getter_name ) do
				return get_cascading_array_downward_from_Object( configuration_name )
			end
		end
	end

	######################################
	#  define_configuration_hash_setter  #
	######################################
	
	def define_configuration_hash_setter( configuration_name )
		configuration_setter_name = ( configuration_name.to_s + '=' ).to_s
		[ self, eigenclass ].each do |klass_or_eigenclass|
			klass_or_eigenclass.class_eval do
				define_method( configuration_setter_name ) do |value|
					# configuration setting hash returns array variable (variable from self)
					existing_hash_variable = instance_variable_get( configuration_variable_name( configuration_name ) )
					unless existing_hash_variable
						existing_hash_variable = Hash.new
						instance_variable_set( configuration_variable_name( configuration_name ), existing_hash_variable )
					end
					return existing_hash_variable
				end
			end
		end
	end

	######################################
	#  define_configuration_hash_getter  #
	######################################
	
	def define_configuration_hash_getter( configuration_name )
		configuration_getter_name = configuration_name
		define_method( configuration_getter_name ) do
			# configuration getter returns current setting value (taken from first superclass with setting)
			# that means first variable that has been set
			return get_cascading_hash_downward_from_Object( configuration_name )
		end
		eigenclass.class_eval do
			define_method( configuration_getter_name ) do
				# configuration getter returns current setting value (taken from first superclass with setting)
				# that means first variable that has been set
				return get_cascading_hash_downward_from_Object( configuration_name )
			end
		end
	end
	
end


# To the tune of "The Events Leading Up to the Collapse of Detective Dulllight"
# ~Oh where did all the code go? / Did you think that it'd stick around for-ever?~

module ::CascadingConfiguration::Array

  array_module = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::
                   CompositingObjects.new( :array, ::CompositingArray, :default, :configuration_array )
  
  ::CascadingConfiguration::Core.enable( self, array_module )

end


# To the tune of "The Events Leading Up to the Collapse of Detective Dulllight"
# ~Oh where did all the code go? / Did you think that it'd stick around for-ever?~

module ::CascadingConfiguration::Array::Unique

  unique_array_module = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::
                          CompositingObjects.new( :unique_array, 
                                                  ::CompositingArray::Unique, 
                                                  :default, 
                                                  :configuration_unique_array )
  
  ::CascadingConfiguration::Core.enable( self, unique_array_module )

end

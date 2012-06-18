
# To the tune of "The Events Leading Up to the Collapse of Detective Dulllight"
# ~Oh where did all the code go? / Did you think that it'd stick around for-ever?~

module ::CascadingConfiguration::Array::Sorted

  sorted_array_module = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::
                          CompositingObjects.new( :sorted_array, 
                                                  ::CompositingArray::Sorted, 
                                                  :default, 
                                                  :configuration_sorted_array )
  
  ::CascadingConfiguration::Core.enable( self, sorted_array_module )

end

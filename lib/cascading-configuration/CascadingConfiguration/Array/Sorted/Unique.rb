
# To the tune of "The Events Leading Up to the Collapse of Detective Dulllight"
# ~Oh where did all the code go? / Did you think that it'd stick around for-ever?~

module ::CascadingConfiguration::Array::Sorted::Unique

  sorted_unique_array_module = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::
                                 CompositingObjects.new( :sorted_unique_array, 
                                                         ::CompositingArray::Sorted::Unique, 
                                                         :default, 
                                                         :unique_sorted_array,
                                                         :configuration_sorted_unique_array,
                                                         :configuration_unique_sorted_array )
  
  ::CascadingConfiguration::Core.enable( self, sorted_unique_array_module )

end

::CascadingConfiguration::Array::Unique::Sorted = ::CascadingConfiguration::Array::Sorted::Unique

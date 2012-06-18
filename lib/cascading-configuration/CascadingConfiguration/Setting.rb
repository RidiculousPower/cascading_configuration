
# To the tune of "The Events Leading Up to the Collapse of Detective Dulllight"
# ~Oh where did all the code go? / Did you think that it'd stick around for-ever?~

module ::CascadingConfiguration::Setting

  setting_module = ::CascadingConfiguration::Core::Module::InheritingValues.new( :setting, :default, :configuration )
  
  ::CascadingConfiguration::Core.enable( self, setting_module )

end

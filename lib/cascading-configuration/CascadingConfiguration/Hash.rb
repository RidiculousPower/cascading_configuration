
# To the tune of "The Events Leading Up to the Collapse of Detective Dulllight"
# ~Oh where did all the code go? / Did you think that it'd stick around for-ever?~

module ::CascadingConfiguration::Hash

  hash_module = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::
                  CompositingObjects.new( :hash, ::CompositingHash, :default, :configuration_hash )
  
  ::CascadingConfiguration::Core.enable( self, hash_module )

end

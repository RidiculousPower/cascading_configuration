
# @private
module ::CascadingConfiguration::Core
  
  #################
  #  self.enable  #
  #################
  
  # @private
  def self.enable( instance, ccm )
    
    instance.const_set( :ClassInstance, ccm )

    instance.extend( ::CascadingConfiguration::Core::EnableInstanceSupport )

    instance.extend( ::ModuleCluster )

    instance.include_or_extend_also_extends( instance::ClassInstance )
    
  end
  
end

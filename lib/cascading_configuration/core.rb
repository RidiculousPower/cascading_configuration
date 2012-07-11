
# @private
module ::CascadingConfiguration::Core
  
  #################
  #  self.enable  #
  #################
  
  # @private
  def self.enable( instance, ccm )
    
    instance.const_set( :ClassInstance, ccm )

    # Enable module instance so that when included it creates instance support
    instance.extend( ::CascadingConfiguration::Core::EnableInstanceSupport )

    instance.extend( ::Module::Cluster )

    instance.cluster( :cascading_configuration ).after_include.extend( instance::ClassInstance )
    instance.cluster( :cascading_configuration ).after_extend.extend( instance::ClassInstance )
    
  end
  
end

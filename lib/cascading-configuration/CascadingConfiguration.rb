
module CascadingConfiguration
  
  ###################
  #  self.included  #
  ###################
  
  def self.included( class_or_module )
    class_or_module.instance_eval do
      include CascadingConfiguration::Setting
      include CascadingConfiguration::Array
      include CascadingConfiguration::Hash
    end
  end
    
end

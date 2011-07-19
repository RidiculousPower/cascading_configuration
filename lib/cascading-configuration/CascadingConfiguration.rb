
module CascadingConfiguration
  
	include CascadingConfiguration::Variable

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

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( class_or_module )
    class_or_module.instance_eval do
      extend CascadingConfiguration::Setting
      extend CascadingConfiguration::Array
      extend CascadingConfiguration::Hash
    end
  end
    
end

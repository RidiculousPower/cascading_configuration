
module CascadingConfiguration
  
  ###################
  #  self.included  #
  ###################
  
  def self.included( class_or_module )
    class_or_module.instance_eval do
      include CascadingConfiguration::ConfigurationSetting
      include CascadingConfiguration::ConfigurationSettingsArray
      include CascadingConfiguration::ConfigurationSettingsHash
    end
  end
    
end

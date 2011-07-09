
require_relative '../../lib/cascading-configuration.rb'

describe CascadingConfiguration::ConfigurationSetting do
  
  ################################
	#  attr_configuration_setting  #
	################################
  
  it 'can define a configuration setting, which is the primary interface' do
    class CascadingConfiguration::ConfigurationSetting::Mock
      attr_configuration_setting :some_other_configuration
      self.some_other_configuration = :our_setting_value
      some_other_configuration.should == :our_setting_value
    end
    class CascadingConfiguration::ConfigurationSetting::Mocksub1 < CascadingConfiguration::ConfigurationSetting::Mock
      some_other_configuration.should == :our_setting_value
      self.some_other_configuration = :our_other_setting_value
      some_other_configuration.should == :our_other_setting_value
    end
    class CascadingConfiguration::ConfigurationSetting::Mocksub2 < CascadingConfiguration::ConfigurationSetting::Mocksub1
      some_other_configuration.should == :our_other_setting_value
      self.some_other_configuration = :a_third_setting_value
      some_other_configuration.should == :a_third_setting_value
    end
  end
    
end

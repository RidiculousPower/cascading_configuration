
require_relative '../../../lib/cascading-configuration.rb'

describe CascadingConfiguration::ClassInstance do

	###############################
	#  attr_configuration_prefix  #
	###############################

  it 'can return the first configuration variable prefix available from the ancestor chain, starting with class' do
    class CascadingConfiguration::ConfigurationVariable::ClassInstance::Mock
      extend CascadingConfiguration::ConfigurationVariable::ClassInstance
      attr_configuration_prefix  '__some_prefix__'
    end
    class CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub1 < CascadingConfiguration::ConfigurationVariable::ClassInstance::Mock
    end
    CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub1.attr_configuration_prefix.should == '__some_prefix__'
    CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub1.attr_configuration_prefix = '__some_other_prefix__'
    CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub1.attr_configuration_prefix.should == '__some_other_prefix__'
    class CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub2 < CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub1
    end
    CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub2.attr_configuration_prefix.should == '__some_other_prefix__'
    CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub2.attr_configuration_prefix = '__yet_another_prefix__'
    CascadingConfiguration::ConfigurationVariable::ClassInstance::Mocksub2.attr_configuration_prefix.should == '__yet_another_prefix__'
  end

end

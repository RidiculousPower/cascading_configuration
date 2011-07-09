
require_relative '../../../lib/cascading-configuration.rb'

describe CascadingConfiguration::ObjectInstance do

	###############################
	#  attr_configuration_prefix  #
	###############################

  it 'can return the first configuration variable prefix available from the ancestor chain, starting with an instance' do
    class CascadingConfiguration::ConfigurationVariable::ObjectInstance::Mock
      include CascadingConfiguration::ConfigurationVariable::ObjectInstance
      extend CascadingConfiguration::ConfigurationVariable::ClassInstance
      attr_configuration_prefix  '__some_prefix__'
    end
    CascadingConfiguration::ConfigurationVariable::ObjectInstance::Mock.new.instance_eval do
      attr_configuration_prefix.should == '__some_prefix__'
      attr_configuration_prefix  '__some_other_prefix__'
      attr_configuration_prefix.should == '__some_other_prefix__'
    end
  end

end

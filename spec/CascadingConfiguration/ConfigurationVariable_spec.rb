
require_relative '../../lib/cascading-configuration.rb'

describe CascadingConfiguration::ConfigurationVariable do

	#################################
	#  attr_configuration_prefix    #
	#  attr_configuration_prefix=   #
	#  configuration_variable_name  #
	#################################
	
	it 'Can set a configuration prefix and return an appropriate configuration variable name for a configuration name' do
	  class CascadingConfiguration::ConfigurationVariable::Mock
	    include CascadingConfiguration::ConfigurationVariable
      attr_configuration_prefix  '__some_prefix__'
      attr_configuration_prefix.should == '__some_prefix__'
      configuration_variable_name( 'some_configuration' ).should == :@__some_prefix__some_configuration
    end
  end
	
end

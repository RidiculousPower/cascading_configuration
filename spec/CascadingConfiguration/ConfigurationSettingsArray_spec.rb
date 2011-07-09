
require_relative '../../lib/cascading-configuration.rb'

describe CascadingConfiguration::ConfigurationSettingsArray do
	
  ##############################
	#  attr_configuration_array  #
	##############################
  
  it 'can define a configuration array, which is the primary interface' do
    class CascadingConfiguration::ConfigurationSettingsArray::Mock
      attr_configuration_array :configuration_setting
      configuration_setting.should == []
      configuration_setting.push( :a_configuration )
      configuration_setting.should == [ :a_configuration ]
    end
    CascadingConfiguration::ConfigurationSettingsArray::Mocksub1.configuration_setting.should == [ :a_configuration ]
    CascadingConfiguration::ConfigurationSettingsArray::Mocksub1.configuration_setting.push( :another_configuration)
    CascadingConfiguration::ConfigurationSettingsArray::Mocksub1.configuration_setting.should == [ :a_configuration, :another_configuration ]

    ##################################### First Configuration ###############################################

  	#########
  	#  []=  #
  	#########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting[ 0 ] = :setting
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :setting ]

  	###########
  	#  clear  #
  	###########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.clear
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == []

  	#######
  	#  +  #
  	#######

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting += [ :setting, :other_setting ]
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :setting, :other_setting ]

  	#######
  	#  -  #
  	#######

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting -= [ :other_setting ]
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :setting ]

  	########
  	#  <<  #
  	########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting << :other_setting
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :setting, :other_setting ]

  	#########
  	#  pop  #
  	#########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.pop.should == :other_setting
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :setting ]

  	##########
  	#  push  #
  	##########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.push( :other_setting )
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :setting, :other_setting ]

  	###########
  	#  shift  #
  	###########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.shift.should == :setting
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :other_setting ]

  	###########
  	#  slice  #
  	###########

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.slice( 0, 1 ).should == :other_setting
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == []

  	############
  	#  slice!  #
  	############

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting = [ :setting, :other_setting ]
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.slice( 0, 1 ).should == :setting
    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.should == [ :other_setting ]

  	#######################
  	#  included_elements  #
  	#######################

    CascadingConfiguration::ConfigurationSettingsArray::Mock.configuration_setting.included_elements.should == [ :other_setting ]

    ##################################### Inherited Configuration ###########################################

  	#########
  	#  []=  #
  	#########

  	###########
  	#  clear  #
  	###########

  	#######
  	#  +  #
  	#######

  	#######
  	#  -  #
  	#######

  	########
  	#  <<  #
  	########

  	#########
  	#  pop  #
  	#########

  	##########
  	#  push  #
  	##########

  	###########
  	#  shift  #
  	###########

  	###########
  	#  slice  #
  	###########

  	############
  	#  slice!  #
  	############

  	#######################
  	#  included_elements  #
  	#######################

    ###################################### Instance Configuration ###########################################

  	#########
  	#  []=  #
  	#########

  	###########
  	#  clear  #
  	###########

  	#######
  	#  +  #
  	#######

  	#######
  	#  -  #
  	#######

  	########
  	#  <<  #
  	########

  	#########
  	#  pop  #
  	#########

  	##########
  	#  push  #
  	##########

  	###########
  	#  shift  #
  	###########

  	###########
  	#  slice  #
  	###########

  	############
  	#  slice!  #
  	############

  	#######################
  	#  included_elements  #
  	#######################

  end
  
end

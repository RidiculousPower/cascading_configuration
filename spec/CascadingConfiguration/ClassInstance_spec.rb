
describe CascadingConfiguration::ClassInstance do

	########################################
  #  get_configuration_searching_upward  #
  ########################################

  it 'can get a configuration setting searching upward from a given class' do
    class CascadingConfiguration::ConfigurationSetting::Mock
      include CascadingConfiguration::ConfigurationSetting
      @some_variable = :some_setting
    end
    CascadingConfiguration::ConfigurationSetting::Mock.instance_variable_get( :@some_variable ).should == :some_setting
    CascadingConfiguration::ConfigurationSetting.get_configuration_searching_upward( CascadingConfiguration::ConfigurationSetting::Mock, :some_variable ).should == :some_setting
    class CascadingConfiguration::ConfigurationSetting::Mocksub1 < CascadingConfiguration::ConfigurationSetting::Mock
      @some_variable = :some_other_setting
    end
    CascadingConfiguration::ConfigurationSetting::Mocksub1.instance_variable_get( :@some_variable ).should == :some_other_setting
    CascadingConfiguration::ConfigurationSetting.get_configuration_searching_upward( CascadingConfiguration::ConfigurationSetting::Mocksub1, :some_variable ).should == :some_other_setting
    class CascadingConfiguration::ConfigurationSetting::Mocksub2 < CascadingConfiguration::ConfigurationSetting::Mocksub1
      @some_variable = :yet_another_setting
    end
    CascadingConfiguration::ConfigurationSetting::Mocksub2.instance_variable_get( :@some_variable ).should == :yet_another_setting
    CascadingConfiguration::ConfigurationSetting.get_configuration_searching_upward( CascadingConfiguration::ConfigurationSetting::Mocksub2, :some_variable ).should == :yet_another_setting
  end
  
  ##############################################
  #  get_cascading_array_downward_from_Object  #
  ##############################################

  it 'can get a configuration array searching downward from Object to a given class' do
    class CascadingConfiguration::ConfigurationSettingsArray::Mock
      include CascadingConfiguration::ConfigurationSettingsArray
      @configuration_var = [ :some_configuration ]
    end
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( CascadingConfiguration::ConfigurationSettingsArray::Mock, :configuration_var ).should == [ :some_configuration ]
    class CascadingConfiguration::ConfigurationSettingsArray::Mocksub1 < CascadingConfiguration::ConfigurationSettingsArray::Mock
      @configuration_var = [ :some_other_configuration ]
    end
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( CascadingConfiguration::ConfigurationSettingsArray::Mocksub1, :configuration_var ).should == [ :some_configuration, :some_other_configuration ]
    class CascadingConfiguration::ConfigurationSettingsArray::Mocksub2 < CascadingConfiguration::ConfigurationSettingsArray::Mocksub1
      @configuration_var = [ :yet_another_configuration ]
    end
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( CascadingConfiguration::ConfigurationSettingsArray::Mocksub2, :configuration_var ).should == [ :some_configuration, :some_other_configuration, :yet_another_configuration ]
  end

  ##################################################
  #  self.get_cascading_hash_downward_from_Object  #
  ##################################################
  
  it 'can get a configuration hash searching downward from Object to a given class' do
    
  end



end


describe CascadingConfiguration::ObjectInstance do

  ########################################
  #  get_configuration_searching_upward  #
  ########################################

  it 'can get a configuration setting searching upward from a given instance' do
    object_instance = CascadingConfiguration::ConfigurationSetting::Mock.new
    object_instance.instance_variable_get( :@some_variable ).should == nil
    CascadingConfiguration::ConfigurationSetting.get_configuration_searching_upward( object_instance, :some_variable ).should == :some_setting
    object_instance = CascadingConfiguration::ConfigurationSetting::Mocksub1.new
    object_instance.instance_variable_get( :@some_variable ).should == nil
    CascadingConfiguration::ConfigurationSetting.get_configuration_searching_upward( object_instance, :some_variable ).should == :some_other_setting
    object_instance = CascadingConfiguration::ConfigurationSetting::Mocksub2.new
    object_instance.instance_variable_get( :@some_variable ).should == nil
    CascadingConfiguration::ConfigurationSetting.get_configuration_searching_upward( object_instance, :some_variable ).should == :yet_another_setting
  end
  
  ##############################################
  #  get_cascading_array_downward_from_Object  #
  ##############################################

  it 'can get a configuration array searching downward from Object to a given instance' do
    object_instance = CascadingConfiguration::ConfigurationSettingsArray::Mock.new
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( object_instance, :configuration_var ).should == [ :some_configuration ]
    object_instance.instance_variable_set( :@configuration_var, [ :more_configuration ] )
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( object_instance, :configuration_var ).should == [ :more_configuration, :some_configuration ]    
    object_instance = CascadingConfiguration::ConfigurationSettingsArray::Mocksub1.new
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( object_instance, :configuration_var ).should == [ :some_configuration, :some_other_configuration ]
    object_instance.instance_variable_set( :@configuration_var, [ :more_configuration ] )
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( object_instance, :configuration_var ).should == [ :more_configuration, :some_configuration, :some_other_configuration ]
    object_instance = CascadingConfiguration::ConfigurationSettingsArray::Mocksub2.new
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( object_instance, :configuration_var ).should == [ :some_configuration, :some_other_configuration, :yet_another_configuration ]
    object_instance.instance_variable_set( :@configuration_var, [ :more_configuration ] )
    CascadingConfiguration::ConfigurationSettingsArray.get_cascading_array_downward_from_Object( object_instance, :configuration_var ).should == [ :more_configuration, :some_configuration, :some_other_configuration, :yet_another_configuration ]
  end

  #############################################
  #  get_cascading_hash_downward_from_Object  #
  #############################################
  
  it 'can get a configuration hash searching downward from Object to a given instance' do
  end
  
end

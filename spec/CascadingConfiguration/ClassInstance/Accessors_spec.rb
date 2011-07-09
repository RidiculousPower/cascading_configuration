
describe ClassInstance::CascadingConfiguration::Accessors do

  #################################
	#  define_configuration_setter  #
	#  define_configuration_getter  #
	#################################

  it 'can define a method to get and set configuration value' do
    # setter
    setter_method_name = ( :some_configuration.to_s + '=' ).to_sym
    CascadingConfiguration::ConfigurationSetting.define_configuration_setter( CascadingConfiguration::ConfigurationSetting::Mock, :some_configuration )
    CascadingConfiguration::ConfigurationSetting::Mock.methods.include?( setter_method_name ).should == true
    CascadingConfiguration::ConfigurationSetting::Mock.instance_methods.include?( setter_method_name ).should == true
    CascadingConfiguration::ConfigurationSetting::Mock.some_configuration = :a_setting_not_yet_used
    # getter
    CascadingConfiguration::ConfigurationSetting.define_configuration_getter( CascadingConfiguration::ConfigurationSetting::Mock, :some_configuration )
    CascadingConfiguration::ConfigurationSetting::Mock.methods.include?( :some_configuration ).should == true
    CascadingConfiguration::ConfigurationSetting::Mock.instance_methods.include?( :some_configuration ).should == true
    CascadingConfiguration::ConfigurationSetting::Mock.some_configuration.should == :a_setting_not_yet_used
  end
	
  ############################################
	#  define_configuration_array_setter  #
	#  define_configuration_array_getter  #
	############################################

  it 'can define a method to get and modify the configuration array' do
    # setter
    CascadingConfiguration::ConfigurationSettingsArray.define_configuration_setter( CascadingConfiguration::ConfigurationSettingsArray::Mock, :some_configuration )
    CascadingConfiguration::ConfigurationSettingsArray::Mock.methods.include?( :some_configuration= ).should == true
    CascadingConfiguration::ConfigurationSettingsArray::Mock.instance_methods.include?( :some_configuration= ).should == true
    # getter
    CascadingConfiguration::ConfigurationSettingsArray.define_configuration_getter( CascadingConfiguration::ConfigurationSettingsArray::Mock, :some_configuration )
    CascadingConfiguration::ConfigurationSettingsArray::Mock.methods.include?( :some_configuration ).should == true
    CascadingConfiguration::ConfigurationSettingsArray::Mock.instance_methods.include?( :some_configuration ).should == true
    CascadingConfiguration::ConfigurationSettingsArray::Mock.some_configuration = [ :a_setting_not_yet_used ]
    CascadingConfiguration::ConfigurationSettingsArray::Mock.some_configuration.should == [ :a_setting_not_yet_used ]
    return_val = CascadingConfiguration::ConfigurationSettingsArray::Mock.some_configuration
    return_val.push( :some_other_setting_not_yet_used )
    puts 'id1: ' + return_val.__id__.to_s
    puts 'id2: ' + CascadingConfiguration::ConfigurationSettingsArray::Mock.some_configuration.__id__.to_s
    puts 'id3: ' + CascadingConfiguration::ConfigurationSettingsArray::Mock.some_configuration.__id__.to_s
    CascadingConfiguration::ConfigurationSettingsArray::Mock.some_configuration.should == [ :a_setting_not_yet_used, :some_other_setting_not_yet_used ]
	end

  ###########################################
	#  self.define_configuration_hash_setter  #
	#  self.define_configuration_hash_getter  #
	###########################################

  it 'can define a method to get and modify the configuration hash' do
	end

end

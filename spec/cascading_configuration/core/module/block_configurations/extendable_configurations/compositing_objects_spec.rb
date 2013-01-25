
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects do

  ##############################
  #  initialize                #
  #  compositing_object_class  #
  ##############################
  
  it 'can initialize with a compositing object class' do

    class_instance = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects.new( :setting, ::Array::Compositing, '' )
    ccm = ::Module.new do
      ::CascadingConfiguration::Core.enable_instance_as_cascading_configuration_module( self, class_instance )
    end

    class_instance.module_type_name.should == :setting
    class_instance.module_type_name_aliases.should == [ '' ]
    class_instance.compositing_object_class.should == ::Array::Compositing

  end
    
end

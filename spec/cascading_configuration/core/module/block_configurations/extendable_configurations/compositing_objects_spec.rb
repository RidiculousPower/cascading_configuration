
require_relative '../../../../../../lib/cascading_configuration.rb'

require_relative '../../../../../support/named_class_and_module.rb'

require_relative '../../../module_shared_examples.rb'

describe ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects do
  
  let( :ccm ) do
    ::CascadingConfiguration::Core::Module::
      BlockConfigurations::ExtendableConfigurations::CompositingObjects.new( :setting, compositing_object_class )
  end
  let( :compositing_object_class ) { ::Array::Compositing }

  it_behaves_like :configuration_module

  ##############################
  #  compositing_object_class  #
  ##############################
  
  context '#compositing_object_class' do
    it 'has a class it uses to initialize configurations for cascading configurations downward' do
      ccm.compositing_object_class.should == ::Array::Compositing
    end
  end
    
end

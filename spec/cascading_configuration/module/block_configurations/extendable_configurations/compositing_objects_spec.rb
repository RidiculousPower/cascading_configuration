
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../../module_setup.rb'
require_relative '../../../module_shared_examples.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects do

  setup_module_tests
  
  let( :compositing_object_class ) { ::Array::Compositing }
  
  let( :compositing_object_ccm ) do
    ::CascadingConfiguration::Module::
      BlockConfigurations::ExtendableConfigurations::
      CompositingObjects.new( ccm_name, compositing_object_class, *ccm_aliases )
  end
  
  it_behaves_like :configuration_module do
    let( :instance ) { compositing_object_ccm }
  end

  ##############################
  #  compositing_object_class  #
  ##############################
  
  context '#compositing_object_class' do
    it 'has a class it uses to initialize configurations for cascading configurations downward' do
      compositing_object_ccm.compositing_object_class.should == ::Array::Compositing
    end
  end
    
end

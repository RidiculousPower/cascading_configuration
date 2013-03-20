# -*- encoding : utf-8 -*-

require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../../module_setup.rb'
require_relative '../../../module_shared_examples.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects do

  setup_module_tests
  
  let( :ccm_name ) { :array }
  
  let( :compositing_object_class ) { ::Array::Compositing }
  
  let( :compositing_object_ccm ) do
    ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::
      CompositingObjects.new( ccm_name, compositing_object_class, *ccm_aliases )
  end
  
  it_behaves_like :configuration_module do
    let( :instance ) { compositing_object_ccm }
  end

end

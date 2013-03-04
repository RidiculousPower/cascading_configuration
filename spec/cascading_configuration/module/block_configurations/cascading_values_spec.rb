# -*- encoding : utf-8 -*-

require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../../../support/named_class_and_module.rb'

require_relative '../../module_setup.rb'
require_relative '../../module_shared_examples.rb'
require_relative 'cascading_values/configuration_setup.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::CascadingValues do

  setup_module_tests
  setup_cascading_values_configuration_tests
  
  it_behaves_like :configuration_module do
    let( :instance ) do 
      instance = ::CascadingConfiguration::Module::BlockConfigurations::CascadingValues.new( ccm_name, *ccm_aliases )
      instance.name( :InheritingValuesInstance )
      instance
    end
  end

end

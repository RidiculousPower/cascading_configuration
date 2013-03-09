# -*- encoding : utf-8 -*-

require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../../../support/named_class_and_module.rb'

require_relative '../../module_setup.rb'
require_relative '../../module_shared_examples.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations do
  
  setup_module_tests
  
  let( :extendable_configurations_ccm ) do
    ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations.new( ccm_name, *ccm_aliases )
  end
  
  it_behaves_like :configuration_module do
    let( :instance ) { extendable_configurations_ccm }
  end
  
  #############################
  #  parse_extension_modules  #
  #############################

  context '#parse_extension_modules' do
    let( :instance ) { ::Module.new.name( :Instance ) }
    let( :moduleA ) { ::Module.new.name( :ModuleA ) }
    let( :moduleB ) { ::Module.new.name( :ModuleB ) }
    let( :moduleC ) { ::Module.new.name( :ModuleC ) }
    let( :moduleD ) { ::Module.new.name( :ModuleD ) }
    let( :names_modules ) { [ :name1, :name2, moduleA, :name3, moduleB, :name4, :name5, moduleC, moduleD, :name6 ] }
    let( :names_modules_hash ) { extendable_configurations_ccm.parse_extension_modules( instance, names_modules ) }
    let( :modules ) { [ moduleA, moduleB, moduleC, moduleD ] }
    it 'can parse extension modules from names' do
      names_modules_hash.should == { :name1 => modules,
                                     :name2 => modules,
                                     :name3 => modules,
                                     :name4 => modules,
                                     :name5 => modules,
                                     :name6 => modules }

    end
  end
  
end

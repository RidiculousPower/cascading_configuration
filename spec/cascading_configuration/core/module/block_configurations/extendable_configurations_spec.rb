
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../module_shared_examples.rb'

describe ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations do
  
  let( :ccm ) { ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations.new( :setting ) }
  
  it_behaves_like :configuration_module
  
  #############################
  #  parse_extension_modules  #
  #############################

  context '#parse_extension_modules' do
    let( :moduleA ) { ::Module.new.name( :ModuleA ) }
    let( :moduleB ) { ::Module.new.name( :ModuleB ) }
    let( :moduleC ) { ::Module.new.name( :ModuleC ) }
    let( :moduleD ) { ::Module.new.name( :ModuleD ) }
    let( :names_modules ) { [ :name1, :name2, moduleA, :name3, moduleB, :name4, :name5, moduleC, moduleD, :name6 ] }
    let( :names_modules_hash ) { ccm.parse_extension_modules( names_modules ) }
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
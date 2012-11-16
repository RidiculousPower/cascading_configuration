
require_relative '../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations do
  
  #############################
  #  parse_extension_modules  #
  #############################

  it 'can parse extension modules from names' do

    ccm = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations.new( :setting, '' )
    module ModuleA
    end
    module ModuleB
    end
    module ModuleC
    end
    module ModuleD
    end
    names_modules = [ :name1, :name2, ModuleA, :name3, ModuleB, :name4, :name5, ModuleC, ModuleD, :name6 ]
    names_modules_hash = ccm.parse_extension_modules( names_modules )
    modules = [ ModuleA, ModuleB, ModuleC, ModuleD ]
    names_modules_hash.should == { :name1 => modules,
                                   :name2 => modules,
                                   :name3 => modules,
                                   :name4 => modules,
                                   :name5 => modules,
                                   :name6 => modules }

  end

  
end
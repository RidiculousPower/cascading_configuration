
require_relative '../../../../lib/cascading-configuration.rb'

describe ::CascadingConfiguration::Core::Module::ExtendedConfigurations do
  
  #############################
  #  parse_extension_modules  #
  #############################

  it 'can parse extension modules from names' do
    module ::CascadingConfiguration::Core::Module::ParseExtensionModulesMock
      ForInstance = ::Module.new
      InstanceController = ::CascadingConfiguration::Core::InstanceController.new( ForInstance )
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      CCM = ::CascadingConfiguration::Core::Module::ExtendedConfigurations.new( :setting, :default, '' )
      module ModuleA
      end
      module ModuleB
      end
      module ModuleC
      end
      module ModuleD
      end
      names_modules = [ :name1, :name2, ModuleA, :name3, ModuleB, :name4, :name5, ModuleC, ModuleD, :name6 ]
      names_modules_hash = CCM.class.parse_extension_modules( InstanceController, Encapsulation, *names_modules )
      modules = [ ModuleA, ModuleB, ModuleC, ModuleD ]
      names_modules_hash.should == { :name1 => modules,
                                     :name2 => modules,
                                     :name3 => modules,
                                     :name4 => modules,
                                     :name5 => modules,
                                     :name6 => modules }
    end
  end

  
end
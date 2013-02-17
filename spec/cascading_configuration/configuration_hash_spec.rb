
require_relative '../../lib/cascading_configuration.rb'

require_relative '../support/named_class_and_module.rb'

require_relative 'configuration_inheritance.rb'

describe CascadingConfiguration::ConfigurationHash do
  # generic module
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module.new( 'config_module' ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration }
  end
  # inheriting values
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module::InheritingValues.new( 'config_module' ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::InheritingValues::Configuration }
  end
  # block configurations
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module::BlockConfigurations.new( 'config_module' ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::BlockConfigurations::Configuration }
  end
  # extendable configurations
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations.new( 'config_module' ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::Configuration }
  end
  # compositing objects
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects.new( 'config_module', ::Array::Compositing ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration }
  end
  # compositing hash
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Hash.new( 'config_module', ::Hash::Compositing ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Hash::Configuration }
  end
  # compositing array
  it_behaves_like :configuration_inheritance do
    let( :configuration_module ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Array.new( 'config_module', ::Array::Compositing ) }  
    let( :configuration_class ) { ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Array::Configuration }
  end
end


require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Core::Module::Configuration::ClassConfiguration do

  let( :instance ) { ::Class.new.name( :ClassInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Core::Module::Configuration::ClassConfiguration }
  
  it_behaves_like ::CascadingConfiguration::Core::Module::Configuration
  
end


require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../configuration.rb'

describe ::CascadingConfiguration::Module::Configuration::ClassConfiguration do

  let( :instance ) { ::Class.new.name( :ClassInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration::ClassConfiguration }
  
  it_behaves_like ::CascadingConfiguration::Module::Configuration
  
end

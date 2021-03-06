# -*- encoding : utf-8 -*-

require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../configuration_shared.rb'
require_relative '../configuration_setup.rb'

describe ::CascadingConfiguration::Module::Configuration::InstanceConfiguration do

  setup_configuration_tests

  let( :parent_instance ) { ::Object.new.name( :ParentInstance ) }
  let( :parent_instance_two ) { ::Object.new.name( :ParentInstanceTwo ) }
  let( :child_instance ) { ::Object.new.name( :ChildInstance ) }
  let( :configuration_class ) { ::CascadingConfiguration::Module::Configuration }

  it_behaves_like ::CascadingConfiguration::Module::Configuration

end

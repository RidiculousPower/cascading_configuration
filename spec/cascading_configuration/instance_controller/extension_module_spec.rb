# -*- encoding : utf-8 -*-

require_relative '../../../lib/cascading_configuration.rb'

require_relative '../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::InstanceController::ExtensionModule do
  
  let( :instance ) do
    ::Module.new do
      def self.method_in_object_but_not_module
      end
    end.name( :Instance )
  end
  let( :instance_controller ) { ::CascadingConfiguration::InstanceController.new( instance ) }
  let( :ccm ) do
    ::CascadingConfiguration::InstanceController::ExtensionModule.new( instance_controller, :some_configuration )
  end
  
  ################
  #  initialize  #
  ################
  
  it 'has an instance controller' do
    ccm.instance_controller.should == instance_controller
  end
  
  it 'has a type name' do
    ccm.configuration_name.should == :some_configuration
  end
  
  ##################
  #  alias_method  #
  ##################
  
  it 'can pend method aliases' do
    ccm.alias_method( :alias_name, :method_in_object_but_not_module )
    instance.respond_to?( :alias_name ).should == false
    instance.extend( ccm )
    instance.respond_to?( :alias_name ).should == true
  end

end

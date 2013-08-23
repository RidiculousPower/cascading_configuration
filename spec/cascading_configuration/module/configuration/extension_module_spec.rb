# -*- encoding : utf-8 -*-

require_relative '../../../../lib/cascading_configuration.rb'

require_relative '../../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::Module::Configuration::ExtensionModule do
  
  let( :instance ) do
    ::Module.new do
      def self.method_in_object_but_not_module
      end
    end.name( :Instance )
  end
  let( :extension_module ) do
    ::CascadingConfiguration::Module::Configuration::ExtensionModule.new( instance, :some_configuration )
  end
  
  ################
  #  initialize  #
  ################
  
  it 'has a type name' do
    extension_module.configuration_name.should == :some_configuration
  end
  
  ##################
  #  alias_method  #
  ##################
  
  it 'can pend method aliases' do
    extension_module.alias_method( :alias_name, :method_in_object_but_not_module )
    instance.respond_to?( :alias_name ).should == false
    instance.extend( extension_module )
    instance.respond_to?( :alias_name ).should == true
  end

end

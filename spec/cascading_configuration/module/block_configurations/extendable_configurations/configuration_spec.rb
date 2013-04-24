# -*- encoding : utf-8 -*-

require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::Configuration do

  let( :configuration_module ) do
    ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations.new( :ccm, ::Array::Compositing )
  end
  
  let( :configuration_class ) do
    ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::Configuration
  end
  
  let( :parent_instance ) { ::Module.new.name( :ParentInstance ) }
  let( :parent_instance_two ) { ::Module.new.name( :ParentInstanceTwo ) }
  let( :child_instance ) { ::Module.new.name( :ChildInstance ) }

  let( :parent_configuration ) do
    configuration_class.new( parent_instance, 
                             configuration_module, 
                             :parent_name, 
                             :parent_name=, 
                             *parent_extension_modules,
                             & parent_extension_block )
  end
  let( :parent_configuration_two ) do
    configuration_class.new( parent_instance_two, 
                             configuration_module, 
                             :parent_two_name?, 
                             :parent_two=, 
                             *parent_two_extension_modules,
                             & parent_two_extension_block )
  end
  let( :child_configuration ) do
    configuration_class.new«inheriting_configuration»( child_instance, 
                                                 parent_configuration, 
                                                 :include, 
                                                 *child_extension_modules,
                                                 & child_extension_block )
  end
  
  let( :extension_A ) { ::Module.new.name( :ExtensionModuleA ) }
  let( :parent_extension_modules ) { [ extension_A ] }
  let( :parent_two_extension_modules ) { [ ] }
  let( :child_extension_modules ) { [ ] }

  let( :parent_extension_block ) do
    ::Proc.new do
      def some_method
        puts 'whoo!'
      end
    end
  end
  let( :parent_extension_block_module ) do
    parent_instance_controller.const_get( 'ExtensionModule«parent_name»' )
  end
  let( :parent_instance_controller ) do
    ::CascadingConfiguration::InstanceController.instance_controller( parent_instance )
  end
  let( :parent_two_extension_block ) { nil }
  let( :child_extension_block ) { nil }
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  context '#permits_multiple_parents?' do
    it 'permits multiple parents' do
      parent_configuration.permits_multiple_parents?.should == false
    end
  end

  #######################
  #  extension_modules  #
  #######################

  context '#extension_modules' do
    it 'can track extension modules' do
      parent_configuration.extension_modules.is_a?( ::Array::Compositing::Unique ).should == true
    end
    it 'will include modules passed with configuration names (youngest => oldest), creating an extension module for block if passed' do
      parent_configuration.extension_modules.should == [ parent_extension_block_module, extension_A ]
    end
    it 'will inherit extension modules' do
      child_configuration.extension_modules.is_parent?( parent_configuration.extension_modules ).should == true
    end
  end

  #####################
  #  register_parent  #
  #####################

  context '#register_parent' do
    it 'can initialize with implied parent registration' do
      child_configuration.parent.should == parent_configuration
    end
  end
  
  #######################
  #  unregister_parent  #
  #######################

  context '#unregister_parent' do
    it 'can remove an existing parent' do
      child_configuration.unregister_parent( parent_configuration )
      child_configuration.parent.should == nil
    end
  end
  
  ####################
  #  replace_parent  #
  ####################

  context '#replace_parent' do
    it 'can replace an existing parent' do
      child_configuration.replace_parent( parent_configuration, parent_configuration_two )
      child_configuration.parent.should == parent_configuration_two
    end
  end

  ##################
  #  has_parents?  #
  ##################

  context '#has_parents?' do
    it 'a parent instance can report it has no parents' do
      parent_configuration.has_parents?.should == false
    end
    it 'a child instance can report it has parents' do
      child_configuration.has_parents?.should == true
    end
  end

  ################
  #  is_parent?  #
  ################

  context '#is_parent?' do
    it 'a child can report a configuration is a parent' do
      child_configuration.is_parent?( parent_configuration ).should == true
    end
    it 'a child can report a configuration is not a parent' do
      child_configuration.is_parent?( parent_configuration_two ).should == false
    end
  end
  
end

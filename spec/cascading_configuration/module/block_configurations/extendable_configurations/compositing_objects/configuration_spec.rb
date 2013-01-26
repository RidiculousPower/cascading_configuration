
require_relative '../../../../../../lib/cascading_configuration.rb'

require_relative '../../../../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration do

  let( :configuration_module ) do
    ::CascadingConfiguration::Module::
      BlockConfigurations::ExtendableConfigurations::CompositingObjects.new( :ccm, ::Array::Compositing )
  end
  
  let( :configuration_class ) do
    ::CascadingConfiguration::Module::
      BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration
  end
  
  let( :parent_instance ) { ::Module.new.name( :ParentInstance ) }
  let( :parent_instance_two ) { ::Module.new.name( :ParentInstanceTwo ) }
  let( :child_instance ) { ::Module.new.name( :ChildInstance ) }

  let( :parent_configuration ) { configuration_class.new( parent_instance, configuration_module, :parent_name ) }
  let( :parent_configuration_two ) do
    configuration_class.new( parent_instance_two, configuration_module, :parent_two_name?, :parent_two= )
  end
  let( :child_configuration ) { configuration_class.new( child_instance, parent_configuration ) }
  
  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  context '#permits_multiple_parents?' do
    it 'permits multiple parents' do
      parent_configuration.permits_multiple_parents?.should == true
    end
  end

  ########################
  #  compositing_object  #
  ########################

  context '#compositing_object' do
    it 'is an alias for value' do
      parent_configuration.method( :compositing_object ).should == parent_configuration.method( :value )
    end
  end

  #######################
  #  extension_modules  #
  #######################

  context '#extension_modules' do
    it 'can track extension modules' do
      parent_configuration.extension_modules.is_a?( ::Array::Compositing::Unique ).should == true
    end
    it 'can inherit extension modules' do
      child_configuration.extension_modules.is_parent?( parent_configuration.extension_modules ).should == true
    end
  end

  #############
  #  parents  #
  #############

  context '#parents' do
    it 'can return parent configurations' do
      child_configuration.parents.should == [ parent_configuration ]
    end
  end

  #####################
  #  register_parent  #
  #####################

  context '#register_parent' do
    it 'can initialize with implied parent registration' do
      child_configuration.parents.should == [ parent_configuration ]
      child_configuration.compositing_object.parents.should == [ parent_configuration.compositing_object ]
    end
    it 'can register multiple parents' do
      child_configuration.register_parent( parent_configuration_two )
      child_configuration.parents.should == [ parent_configuration, parent_configuration_two ]
      child_configuration.compositing_object.parents.should == [ parent_configuration.compositing_object, parent_configuration_two.compositing_object ]
    end
  end
  
  #######################
  #  unregister_parent  #
  #######################

  context '#unregister_parent' do
    it 'can remove an existing parent' do
      child_configuration.unregister_parent( parent_configuration )
      child_configuration.parents.should == [ ]
      child_configuration.compositing_object.parents.should == [ ]
    end
  end
  
  ####################
  #  replace_parent  #
  ####################

  context '#replace_parent' do
    it 'can replace an existing parent' do
      child_configuration.replace_parent( parent_configuration, parent_configuration_two )
      child_configuration.parents.should == [ parent_configuration_two ]
      child_configuration.compositing_object.parents.should == [ parent_configuration_two.compositing_object ]
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

  ############
  #  value=  #
  ############
  
  context '#value=' do
    let( :configuration_instance ) { ::Module.new.name( :ConfigurationInstance )}
    let( :configuration ) { ::CascadingConfiguration::Module::
                              BlockConfigurations::ExtendableConfigurations::
                              CompositingObjects::Configuration.new( configuration_instance, 
                                                                     configuration_module, 
                                                                     :configuration_name ) }
    it 'will replace the current values with new contents (assumes object responds to :replace)' do
      configuration.value = [ :A, :B, :C ]
      configuration.value.should == [ :A, :B, :C ]
    end
  end

  ##########################
  #  match_lowest_parents  #
  ##########################

  context '#match_lowest_parents' do
    
    let( :parent_A_instance ) { ::Module.new.name( :Parent_A_Instance ) }
    let( :parent_A_B1_instance ) { ::Module.new.name( :Parent_A_B1_Instance ) }
    let( :parent_A_B1_C1_instance ) { ::Module.new.name( :Parent_A_B1_C1_Instance ) }
    let( :parent_A_B1_C1_D_instance ) { ::Module.new.name( :Parent_A_B1_C1_D_Instance ) }
    let( :parent_A_B1_C1_D_E_instance ) { ::Module.new.name( :Parent_A_B1_C1_D_E_Instance ) }
    let( :parent_A_B1_C2_instance ) { ::Module.new.name( :Parent_A_B1_C2_Instance ) }
    let( :parent_A_B1_C2_D_instance ) { ::Module.new.name( :Parent_A_B1_C2_D_Instance ) }
    let( :parent_A_B2_instance ) { ::Module.new.name( :Parent_A_B2_Instance ) }
    let( :parent_A_B2_C1_instance ) { ::Module.new.name( :Parent_A_B2_C1_Instance ) }
    let( :parent_A_B2_C1_D_instance ) { ::Module.new.name( :Parent_A_B2_C1_D_Instance ) }
    let( :parent_A_B2_C1_D_E_instance ) { ::Module.new.name( :Parent_A_B2_C1_D_E_Instance ) }
    let( :parent_A_B2_C1_D_E_F_instance ) { ::Module.new.name( :Parent_A_B2_C1_D_E_F_Instance ) }

    let( :parent_A ) do
      parent_A = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_instance, configuration_module, :configuration_name )
      parent_A.compositing_object.push( :A )
      parent_A
    end
    let( :parent_A_B1 ) do
      parent_A_B1 = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B1_instance, parent_A )
      parent_A_B1.compositing_object.push( :B )
      parent_A_B1
    end
    let( :parent_A_B1_C1 ) do
      parent_A_B1_C1 = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B1_C1_instance, parent_A_B1 )
      parent_A_B1_C1.compositing_object.push( :C )
      parent_A_B1_C1
    end
    let( :parent_A_B1_C1_D ) do
      parent_A_B1_C1_D = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B1_C1_D_instance, parent_A_B1_C1 )
      parent_A_B1_C1_D.compositing_object.push( :D )
      parent_A_B1_C1_D
    end
    let( :parent_A_B1_C1_D_E ) do
      parent_A_B1_C1_D_E = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B1_C1_D_E_instance, parent_A_B1_C1_D )
      parent_A_B1_C1_D_E.compositing_object.push( :E )
      parent_A_B1_C1_D_E
    end
    let( :parent_A_B1_C2 ) do
      parent_A_B1_C2 = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B1_C2_instance, parent_A_B1 )
      parent_A_B1_C2.compositing_object.push( :C )
      parent_A_B1_C2
    end
    let( :parent_A_B1_C2_D ) do
      parent_A_B1_C2_D = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B1_C2_D_instance, parent_A_B1_C2 )
      parent_A_B1_C2_D.compositing_object.push( :D )
      parent_A_B1_C2_D
    end
    let( :parent_A_B2 ) do
      parent_A_B2 = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B2_instance, parent_A )
      parent_A_B2.compositing_object.push( :B )
      parent_A_B2
    end
    let( :parent_A_B2_C1 ) do
      parent_A_B2_C1 = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B2_C1_instance, parent_A_B2 )
      parent_A_B2_C1.compositing_object.push( :C )
      parent_A_B2_C1
    end
    let( :parent_A_B2_C1_D ) do
      parent_A_B2_C1_D = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B2_C1_D_instance, parent_A_B2_C1 )
      parent_A_B2_C1_D.compositing_object.push( :D )
      parent_A_B2_C1_D
    end
    let( :parent_A_B2_C1_D_E ) do
      parent_A_B2_C1_D_E = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B2_C1_D_E_instance, parent_A_B2_C1_D )
      parent_A_B2_C1_D_E.compositing_object.push( :E )
      parent_A_B2_C1_D_E
    end
    let( :parent_A_B2_C1_D_E_F ) do
      parent_A_B2_C1_D_E_F = ::CascadingConfiguration::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( parent_A_B2_C1_D_E_F_instance, parent_A_B2_C1_D_E )
      parent_A_B2_C1_D_E_F.compositing_object.push( :F )
      parent_A_B2_C1_D_E_F
    end

    let( :diamond_A_instance ) { ::Module.new.name( :Diamond_A_instance ) }
    let( :diamond_B_instance ) { ::Module.new.name( :Diamond_B_instance ) }
    let( :diamond_C_instance ) { ::Module.new.name( :Diamond_C_instance ) }
    let( :diamond_A ) do
      ::CascadingConfiguration::Module::
        BlockConfigurations::ExtendableConfigurations::
        CompositingObjects::Configuration.new( diamond_A_instance, parent_A_B2_C1_D_E, parent_A_B1_C2_D )
    end
    let( :diamond_B ) do
      ::CascadingConfiguration::Module::
        BlockConfigurations::ExtendableConfigurations::
        CompositingObjects::Configuration.new( diamond_B_instance, parent_A_B2_C1, parent_A_B1 )
    end
    let( :diamond_C ) do
      ::CascadingConfiguration::Module::
        BlockConfigurations::ExtendableConfigurations::
        CompositingObjects::Configuration.new( diamond_C_instance, parent_A, parent_A_B1_C2 )
    end

    it 'match the lowest parents for a condition' do
      diamond_A.match_lowest_parents do |this_parent|
        ! this_parent.compositing_object.include?( :B )
      end.should == [ parent_A ]
    end

    it 'match the lowest parents for a condition' do
      diamond_B.match_lowest_parents do |this_parent|
        ! this_parent.compositing_object.include?( :C )
      end.should == [ parent_A_B2, parent_A_B1 ]
    end

    it 'match the lowest parents for a condition' do
      diamond_C.match_lowest_parents do |this_parent|
        ! this_parent.compositing_object.include?( :C )
      end.should == [ parent_A, parent_A_B1 ]
    end

  end
  
end

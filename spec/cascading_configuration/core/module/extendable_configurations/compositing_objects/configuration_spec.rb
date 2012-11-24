
require_relative '../../../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration do

  before :all do
    
    @configuration_module = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects.new( :ccm, ::Array::Compositing )
    @parent_instance = ::Module.new
    @parent_instance_two = ::Object
    @child_instance = ::Object.new

  end
  
  before :each do
    
    configuration_class = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration
    
    @parent_configuration = configuration_class.new( @parent_instance, @configuration_module, :parent_name )
    @parent_configuration_two = configuration_class.new( @parent_instance_two, @configuration_module, :parent_two_name?, :parent_two= )
    @child_configuration = configuration_class.new( @child_instance, @parent_configuration )
    
  end

  ###############################
  #  permits_multiple_parents?  #
  ###############################

  it 'permits multiple parents' do
    @parent_configuration.permits_multiple_parents?.should == true
  end

  ########################
  #  compositing_object  #
  ########################

  it 'is an alias for value' do
    @parent_configuration.method( :compositing_object ).should == @parent_configuration.method( :value )
  end

  it 'should have a compositing object specified by class initialized by default' do
    @parent_configuration.compositing_object.is_a?( @parent_configuration.module.compositing_object_class ).should == true
  end
  
  #######################
  #  extension_modules  #
  #######################

  it 'can track extension modules' do
    @parent_configuration.extension_modules.is_a?( ::Array::Compositing::Unique ).should == true
  end

  it 'can inherit extension modules' do
    @child_configuration.extension_modules.is_parent?( @parent_configuration.extension_modules ).should == true
  end

  #############
  #  parents  #
  #############

  it 'can return parent configurations' do
    @child_configuration.parents.should == [ @parent_configuration ]
  end

  #####################
  #  register_parent  #
  #####################

  it 'can initialize with implied parent registration' do
    @child_configuration.parents.should == [ @parent_configuration ]
    @child_configuration.compositing_object.parents.should == [ @parent_configuration.compositing_object ]
  end

  it 'can register multiple parents' do
    @child_configuration.register_parent( @parent_configuration_two )
    @child_configuration.parents.should == [ @parent_configuration, @parent_configuration_two ]
    @child_configuration.compositing_object.parents.should == [ @parent_configuration.compositing_object, @parent_configuration_two.compositing_object ]
  end
  
  #######################
  #  unregister_parent  #
  #######################

  it 'can remove an existing parent' do
    @child_configuration.unregister_parent( @parent_configuration )
    @child_configuration.parents.should == [ ]
    @child_configuration.compositing_object.parents.should == [ ]
  end
  
  ####################
  #  replace_parent  #
  ####################

  it 'can replace an existing parent' do
    @child_configuration.replace_parent( @parent_configuration, @parent_configuration_two )
    @child_configuration.parents.should == [ @parent_configuration_two ]
    @child_configuration.compositing_object.parents.should == [ @parent_configuration_two.compositing_object ]
  end

  ##################
  #  has_parents?  #
  ##################

  it 'a parent instance can report it has no parents' do
    @parent_configuration.has_parents?.should == false
  end

  it 'a child instance can report it has parents' do
    @child_configuration.has_parents?.should == true
  end

  ################
  #  is_parent?  #
  ################

  it 'a child can report a configuration is a parent' do
    @child_configuration.is_parent?( @parent_configuration ).should == true
  end

  it 'a child can report a configuration is not a parent' do
    @child_configuration.is_parent?( @parent_configuration_two ).should == false
  end

end

describe ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration do

  before :all do
    
    @configuration_module = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects.new( :ccm, ::Array::Compositing )

  end
  
  before :each do
    
    @parent_A_instance = ::Object.new
    @parent_A_B1_instance = ::Object.new
    @parent_A_B1_C1_instance = ::Object.new
    @parent_A_B1_C1_D_instance = ::Object.new
    @parent_A_B1_C1_D_E_instance = ::Object.new
    @parent_A_B1_C2_instance = ::Object.new
    @parent_A_B1_C2_D_instance = ::Object.new
    @parent_A_B2_instance = ::Object.new
    @parent_A_B2_C1_instance = ::Object.new
    @parent_A_B2_C1_D_instance = ::Object.new
    @parent_A_B2_C1_D_E_instance = ::Object.new
    @parent_A_B2_C1_D_E_F_instance = ::Object.new

    @parent_A = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_instance, @configuration_module, :configuration_name )
    @parent_A.compositing_object.push( :A )
    @parent_A_B1 = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B1_instance, @parent_A )
    @parent_A_B1.compositing_object.push( :B )
    @parent_A_B1_C1 = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B1_C1_instance, @parent_A_B1 )
    @parent_A_B1_C1.compositing_object.push( :C )
    @parent_A_B1_C1_D = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B1_C1_D_instance, @parent_A_B1_C1 )
    @parent_A_B1_C1_D.compositing_object.push( :D )
    @parent_A_B1_C1_D_E = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B1_C1_D_E_instance, @parent_A_B1_C1_D )
    @parent_A_B1_C1_D_E.compositing_object.push( :E )
    @parent_A_B1_C2 = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B1_C2_instance, @parent_A_B1 )
    @parent_A_B1_C2.compositing_object.push( :C )
    @parent_A_B1_C2_D = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B1_C2_D_instance, @parent_A_B1_C2 )
    @parent_A_B1_C2_D.compositing_object.push( :D )
    @parent_A_B2 = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B2_instance, @parent_A )
    @parent_A_B2.compositing_object.push( :B )
    @parent_A_B2_C1 = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B2_C1_instance, @parent_A_B2 )
    @parent_A_B2_C1.compositing_object.push( :C )
    @parent_A_B2_C1_D = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B2_C1_D_instance, @parent_A_B2_C1 )
    @parent_A_B2_C1_D.compositing_object.push( :D )
    @parent_A_B2_C1_D_E = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B2_C1_D_E_instance, @parent_A_B2_C1_D )
    @parent_A_B2_C1_D_E.compositing_object.push( :E )
    @parent_A_B2_C1_D_E_F = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @parent_A_B2_C1_D_E_F_instance, @parent_A_B2_C1_D_E )
    @parent_A_B2_C1_D_E_F.compositing_object.push( :F )

    @diamond_A_instance = ::Object.new
    @diamond_A = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @diamond_A_instance, @parent_A_B2_C1_D_E, @parent_A_B1_C2_D )

    @diamond_B_instance = ::Object.new
    @diamond_B = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @diamond_B_instance, @parent_A_B2_C1, @parent_A_B1 )

    @diamond_C_instance = ::Object.new
    @diamond_C = ::CascadingConfiguration::Core::Module::BlockConfigurations::ExtendableConfigurations::CompositingObjects::Configuration.new( @diamond_C_instance, @parent_A, @parent_A_B1_C2 )
    
  end

  ##########################
  #  match_lowest_parents  #
  ##########################

  it 'match the lowest parents for a condition' do
    @diamond_A.match_lowest_parents do |this_parent|
      ! this_parent.compositing_object.include?( :B )
    end.should == [ @parent_A ]
  end

  it 'match the lowest parents for a condition' do
    @diamond_B.match_lowest_parents do |this_parent|
      ! this_parent.compositing_object.include?( :C )
    end.should == [ @parent_A_B2, @parent_A_B1 ]
  end

  it 'match the lowest parents for a condition' do
    @diamond_C.match_lowest_parents do |this_parent|
      ! this_parent.compositing_object.include?( :C )
    end.should == [ @parent_A, @parent_A_B1 ]
  end

  ############
  #  value=  #
  ############
  
  it 'can replace the current values with new contents (assumes object responds to :replace)' do
    @parent_A.value = [ :A, :B, :C ]
    @parent_A.value.should == [ :A, :B, :C ]
  end
  
end

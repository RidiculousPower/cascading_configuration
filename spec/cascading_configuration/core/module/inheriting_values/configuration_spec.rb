
require_relative '../../../../../lib/cascading_configuration.rb'

require_relative '../../../../support/named_class_and_module.rb'

describe ::CascadingConfiguration::Core::Module::InheritingValues::Configuration do

  before :all do

    @configuration_module = ::Module.new
    @parent_instance = ::Module.new
    @parent_instance_two = ::Object
    @child_instance = ::Object.new
    
  end
  
  before :each do
  
    configuration_class = ::CascadingConfiguration::Core::Module::InheritingValues::Configuration
  
    @parent_configuration = configuration_class.new( @parent_instance, @configuration_module, :parent_name )
    @parent_configuration_two = configuration_class.new( @parent_instance_two, @parent_configuration )    
    @child_configuration = configuration_class.new( @child_instance, @parent_configuration_two )
    
  end

  ###############################
  #  permits_multiple_parents?  #
  ###############################
  
  it 'does not permit multiple parents by default' do
    @parent_configuration.permits_multiple_parents?.should == false
  end

  ############
  #  parent  #
  ############
  
  it 'can register/report a parent, which is implied by initializing with an ancestor' do
    @child_configuration.parent.should == @parent_configuration_two
  end
  
  #####################
  #  register_parent  #
  #####################
  
  it 'will keep existing parent if new parent is parent of existing parent' do
    @child_configuration.register_parent( @parent_configuration )
    @child_configuration.parent.should == @parent_configuration_two
  end

  ####################
  #  replace_parent  #
  ####################

  it 'can replace a parent' do
    @child_configuration.replace_parent( @parent_configuration )
    @child_configuration.parent.should == @parent_configuration
  end

  #######################
  #  unregister_parent  #
  #######################

  it 'can remove a parent' do
    @child_configuration.unregister_parent
    @child_configuration.parent.should == nil
  end

  ##################
  #  has_parents?  #
  ##################

  it 'a child can report it has parents' do
    @child_configuration.has_parents?.should == true
  end

  it 'a parent can report it has no parents' do
    @parent_configuration.has_parents?.should == false
  end

  ################
  #  is_parent?  #
  ################
  
  it 'can report if an instance is a parent' do
    @child_configuration.is_parent?( @parent_configuration ).should == true
  end
  
  ##################
  #  match_parent_configuration  #
  ##################

  it 'can match a parent for a condition' do
    @child_configuration.match_parent_configuration do |this_parent|
      this_parent.equal?( @parent_configuration )
    end.should == @parent_configuration
  end

  ###########
  #  value  #
  ###########

  it 'matches value by searching upward for first match' do
    @parent_configuration.value = :some_value
    @child_configuration.value.should == :some_value
  end
  
end

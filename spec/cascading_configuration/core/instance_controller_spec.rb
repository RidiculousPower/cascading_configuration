
require_relative '../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::InstanceController do

  before :all do
    @instance = ::Module.new
    @instance_controller = ::CascadingConfiguration::Core::InstanceController.new( @instance )
  end

  ##############################
  #  initialize                #
  #  instance                  #
  #  self.instance_controller  #
  ##############################
  
  it 'can initialize for an instance' do
    @instance_controller.instance.should == @instance
    @instance::Controller.should == @instance_controller
    ::CascadingConfiguration::Core::InstanceController.instance_controller( @instance ).should == @instance_controller
  end

  ####################
  #  create_support  #
  #  support         #
  ####################

  it 'can manage creation and return of module instances' do
    # should_include
    module_instance_include = @instance_controller.create_support( :include, nil, true, false, false, false )
    @instance_controller.support( :include ).should == module_instance_include
    @instance.ancestors.include?( module_instance_include ).should == true
    @instance.is_a?( module_instance_include ).should == false
    
    # should_extend
    module_instance_extend = @instance_controller.create_support( :extend, false, nil, true, false, false )
    @instance_controller.support( :extend ).should == module_instance_extend
    @instance.ancestors.include?( module_instance_extend ).should == false
    @instance.is_a?( module_instance_extend ).should == true
    
    # should_cascade_includes
    module_instance_cascade_includes = @instance_controller.create_support( :cascade_includes, false, nil, false, true, false )
    @instance_controller.support( :cascade_includes ).should == module_instance_cascade_includes
    @instance.ancestors.include?( module_instance_cascade_includes ).should == false
    @instance.is_a?( module_instance_cascade_includes ).should == false
    
    # should_cascade_extends
    module_instance_cascade_extends = @instance_controller.create_support( :cascade_extends, nil, false, false, false, true )
    @instance_controller.support( :cascade_extends ).should == module_instance_cascade_extends
    @instance.ancestors.include?( module_instance_cascade_extends ).should == false
    @instance.is_a?( module_instance_cascade_extends ).should == false
    
    instance = @instance
    
    another_module_includeA = ::Module.new
    another_module_includeA.instance_eval do
      include instance
      ancestors.include?( module_instance_cascade_includes ).should == true
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == true
    end
    another_module_includeB = ::Module.new
    another_module_includeB.instance_eval do
      include another_module_includeA
      ancestors.include?( module_instance_cascade_includes ).should == true
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == true
    end
    another_module_includeC = ::Module.new
    another_module_includeC.instance_eval do
      include another_module_includeB
      ancestors.include?( module_instance_cascade_includes ).should == true
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == true
    end
    another_module_class_include = ::Class.new
    another_module_class_include.instance_eval do
      include another_module_includeC
      ancestors.include?( module_instance_cascade_includes ).should == true
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == true
    end

    another_module_extendA = ::Module.new
    another_module_extendA.instance_eval do
      extend instance
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == false
    end
    another_module_extendB = ::Module.new
    another_module_extendB.instance_eval do
      extend another_module_extendA
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == false
    end
    another_module_extendC = ::Module.new
    another_module_extendC.instance_eval do
      extend another_module_extendB
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == false
    end
    another_module_class_extend = ::Class.new
    another_module_class_extend.instance_eval do
      extend another_module_extendC
      eigenclass = class << self ; self ; end
      eigenclass.ancestors.include?( module_instance_cascade_extends ).should == false
    end
  end  

  ##############################
  #  create_singleton_support  #
  #  singleton_support         #
  ##############################
  
  it 'can create a cascading support module for singleton (module/class) methods' do
    singleton_support = @instance_controller.create_singleton_support
    @instance_controller.singleton_support.should == singleton_support
  end

  #############################
  #  create_instance_support  #
  #  instance_support         #
  #############################

  it 'can create a cascading support module for instance methods' do
    instance_support = @instance_controller.create_instance_support
    @instance_controller.instance_support.should == instance_support
  end

  ###################################
  #  create_local_instance_support  #
  #  local_instance_support         #
  ###################################

  it 'can create a non-cascading support module supporting the local object and its instances' do
    local_instance_support = @instance_controller.create_local_instance_support
    @instance_controller.local_instance_support.should == local_instance_support
  end

end
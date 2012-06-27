
require_relative '../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::Encapsulation do

  ########################
  #  initialize          #
  #  self.encapsulation  #
  ########################

  it 'can initialize as an independent encapsulation of its features' do
    module ::CascadingConfiguration::Core::Encapsulation::InitializeMock
      Encapsulation = ::CascadingConfiguration::Core::Encapsulation.new( :encapsulation_name )
      Encapsulation.encapsulation_name.should == :encapsulation_name
      ::CascadingConfiguration::Core::Encapsulation.encapsulation( :encapsulation_name ).should == Encapsulation
    end
  end

  ############################
  #  register_configuration  #
  #  has_configurations?     #
  #  has_configuration?      #
  #  configuration_names     #
  #  remove_configuration    #
  ############################
  
  it 'can hold configurations' do
    module ::CascadingConfiguration::Core::Encapsulation::ConfigurationsMock
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      ForInstance = ::Module.new
      CCMMock = ::Module.new do
        def self.create_configuration( encapsulation, instance, this_name )
        end
        def self.initialize_configuration( encapsulation, instance, this_name )
        end
      end
      Encapsulation.instance_eval do
        has_configurations?( ForInstance ).should == false
        has_configuration?( ForInstance, :some_configuration ).should == false
        configuration_names( ForInstance ).should == [ ]
        register_configuration( ForInstance, :some_configuration, CCMMock )
        has_configurations?( ForInstance ).should == true
        has_configuration?( ForInstance, :some_configuration ).should == true
        configuration_names( ForInstance ).should == [ :some_configuration ]
        remove_configuration( ForInstance, :some_configuration )
        has_configurations?( ForInstance ).should == false
        has_configuration?( ForInstance, :some_configuration ).should == false
        configuration_names( ForInstance ).should == [ ]
      end
    end
  end

  #######################################
  #  register_child_for_parent          #
  #  parent_for_configuration           #
  #  register_parent_for_configuration  #
  #######################################
  
  it 'can register children for parents' do
    module ::CascadingConfiguration::Core::Encapsulation::ParentsMock
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      CCMMock = ::Module.new do
        def self.create_configuration( encapsulation, instance, this_name )
        end
        def self.initialize_configuration( encapsulation, instance, this_name )
        end
      end
      Parent = ::Module.new
      Child = ::Module.new
      AnotherParent = ::Module.new
      Encapsulation.module_eval do
        register_configuration( Parent, :some_configuration, CCMMock )
        register_child_for_parent( Child, Parent )
        has_configuration?( Child, :some_configuration ).should == true
        parent_for_configuration( Child, :some_configuration ).should == Parent
        register_configuration( Child, :some_other_configuration, CCMMock )
        register_parent_for_configuration( Child, AnotherParent, :some_other_configuration )
        has_configuration?( Child, :some_other_configuration ).should == true
        parent_for_configuration( Child, :some_other_configuration ).should == AnotherParent
        parents( Child ).include?( AnotherParent ).should == true
      end
    end
  end

  ##############################
  #  parent_for_configuration  #
  ##############################
  
  it 'can find the next ancestor for a configuration name' do
    module ::CascadingConfiguration::Core::Encapsulation::ParentForConfigurationMock
    
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation

      CCMMock = ::Module.new do
        def self.create_configuration( encapsulation, instance, this_name )
        end
        def self.initialize_configuration( encapsulation, instance, this_name )
        end
      end
    
      module MockA
        class << self
          attr_accessor :config_A
        end
      end      
      Encapsulation.register_configuration( MockA, :config_A, CCMMock )

      module MockB
        class << self
          attr_accessor :config_A, :config_B
        end
      end
      Encapsulation.register_child_for_parent( MockB, MockA )
      Encapsulation.register_configuration( MockB, :config_A, CCMMock )
      Encapsulation.register_configuration( MockB, :config_B, CCMMock )
    
      module MockC1
        class << self
          attr_accessor :config_A, :config_B, :config_C1
        end
      end
      Encapsulation.register_child_for_parent( MockC1, MockB )
      Encapsulation.register_configuration( MockC1, :config_A, CCMMock )
      Encapsulation.register_configuration( MockC1, :config_B, CCMMock )
      Encapsulation.register_configuration( MockC1, :config_C1, CCMMock )

      module MockC2
        class << self
          attr_accessor :config_A, :config_B, :config_C2
        end
      end
      Encapsulation.register_child_for_parent( MockC2, MockB )
      Encapsulation.register_configuration( MockC2, :config_A, CCMMock )
      Encapsulation.register_configuration( MockC2, :config_B, CCMMock )
      Encapsulation.register_configuration( MockC2, :config_C2, CCMMock )

      module MockD
        class << self
          attr_accessor :config_A, :config_B, :config_C1, :config_C2
        end
      end
    
      Encapsulation.instance_eval do
    
        register_child_for_parent( MockD, MockC1 )
        register_child_for_parent( MockD, MockC2 )
        register_configuration( MockD, :config_A, CCMMock )
        register_configuration( MockD, :config_B, CCMMock )
        register_configuration( MockD, :config_C1, CCMMock )
        register_configuration( MockD, :config_C2, CCMMock )
      
        parent_for_configuration( MockD, :config_A ).should == MockC2
        parent_for_configuration( MockD, :config_B ).should == MockC2
        parent_for_configuration( MockD, :config_C1 ).should == MockC1
        parent_for_configuration( MockD, :config_C2 ).should == MockC2
      
        parent_for_configuration( MockC2, :config_A ).should == MockB
        parent_for_configuration( MockC2, :config_B ).should == MockB
        parent_for_configuration( MockC2, :config_C1 ).should == nil
        parent_for_configuration( MockC2, :config_C2 ).should == nil
      
        parent_for_configuration( MockC1, :config_A ).should == MockB
        parent_for_configuration( MockC1, :config_B ).should == MockB
        parent_for_configuration( MockC1, :config_C1 ).should == nil
        parent_for_configuration( MockC1, :config_C2 ).should == nil
      
        parent_for_configuration( MockB, :config_A ).should == MockA
        parent_for_configuration( MockB, :config_B ).should == nil
        parent_for_configuration( MockB, :config_C1 ).should == nil
        parent_for_configuration( MockB, :config_C2 ).should == nil
      
        parent_for_configuration( MockA, :config_A ).should == nil
        parent_for_configuration( MockA, :config_B ).should == nil
        parent_for_configuration( MockA, :config_C1 ).should == nil
        parent_for_configuration( MockA, :config_C2 ).should == nil
      
      end
    
    end
    
  end

  ###################################
  #  set_configuration              #
  #  get_configuration              #
  #  has_configuration_value?       #
  #  configuration_variables        #
  #  remove_configuration_variable  #
  ###################################
  
  it 'can set, get and remove configuration variables' do
    module ::CascadingConfiguration::Core::Encapsulation::ConfigurationVariableMock
      Encapsulation = ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      ForInstance = ::Module.new
      Encapsulation.instance_eval do
        has_configuration_value?( ForInstance, :some_variable ).should == false
        set_configuration( ForInstance, :some_variable, :some_value )
        has_configuration_value?( ForInstance, :some_variable ).should == true
        get_configuration( ForInstance, :some_variable ).should == :some_value
        configuration_variables( ForInstance ).should == { :some_variable => :some_value }
        remove_configuration_variable( ForInstance, :some_variable )
        configuration_variables( ForInstance ).should == { }
        has_configuration_value?( ForInstance, :some_variable ).should == false
      end
    end
  end

end

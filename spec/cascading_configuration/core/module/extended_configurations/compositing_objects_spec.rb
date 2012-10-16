
require_relative '../../../../../lib/cascading_configuration.rb'

describe ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects do

  ##############################
  #  initialize                #
  #  compositing_object_class  #
  ##############################
  
  it 'can initialize with a compositing object class' do
    module ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects::InitializeMock
      ClassInstance = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects.new( :setting, ::Array::Compositing, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      CCM::ClassInstance.default_encapsulation.should == ::CascadingConfiguration::Core::Module::DefaultEncapsulation
      CCM::ClassInstance.ccm_name.should == :setting
      CCM::ClassInstance.ccm_aliases.should == [ '' ]
      CCM::ClassInstance.compositing_object_class.should == ::Array::Compositing
    end
  end
  
  #####################################################
  #  create_configuration                             #
  #  initialize_compositing_configuration_for_parent  #
  #####################################################
  
  it 'ensures objects are initialized for each level in hiearchy' do
    module ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects::CreateConfigurationMock

      ClassInstance = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects.new( :setting, ::Array::Compositing, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      
      Encapsulation = :default
      
      # module 1
      Module1 = ::Module.new do
        include CCM
        attr_setting :some_configuration
      end
      Encapsulation.get_configuration_value( Module1, :some_configuration ).is_a?( ::Array::Compositing ).should == true
      Module1.some_configuration.is_a?( ::Array::Compositing ).should == true
    
      # module 2
      Module2 = ::Module.new do
        include Module1
      end
      Encapsulation.get_configuration_value( Module2, :some_configuration ).nil?.should == true
      Module2.some_configuration.is_a?( ::Array::Compositing ).should == true
    
      # module 3
      Module3 = ::Module.new do
        include Module2
      end
      Encapsulation.get_configuration_value( Module3, :some_configuration ).nil?.should == true
      Module3.some_configuration.is_a?( ::Array::Compositing ).should == true
    
      # class 1
      Class1 = ::Class.new do
        include Module3
      end
      Encapsulation.get_configuration_value( Class1, :some_configuration ).nil?.should == true
      Class1.some_configuration.is_a?( ::Array::Compositing ).should == true
    
      # subclass 1
      Class2 = ::Class.new( Class1 )
      Encapsulation.get_configuration_value( Class2, :some_configuration ).nil?.should == true
      Class2.some_configuration.is_a?( ::Array::Compositing ).should == true
    
      # instance
      Instance = Class2.new
      Encapsulation.get_configuration_value( Instance, :some_configuration ).nil?.should == true
      Instance.some_configuration.is_a?( ::Array::Compositing ).should == true
            
    end
    
  end

  #####################
  #  setter           #
  #  getter           #
  #  instance_setter  #
  #  instance_getter  #
  #####################
  
  it 'can set and get values' do
    module ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects::SetterGetterMock
      
      ClassInstance = ::CascadingConfiguration::Core::Module::ExtendedConfigurations::CompositingObjects.new( :setting, ::Array::Compositing, :default, '' )
      CCM = ::Module.new do
        ::CascadingConfiguration::Core.enable( self, ClassInstance )
      end
      
      Encapsulation = :default
      
      # module 1
      Module1 = ::Module.new do
        include CCM
        attr_setting :some_configuration
        self.some_configuration.should == [ ]
        self.some_configuration.push( :some_value )
        self.some_configuration.should == [ :some_value ]
        self.some_configuration = [ :some_other_value ]
        self.some_configuration.should == [ :some_other_value ]
      end
    
      Class1 = ::Class.new do
        include Module1
      end
      
      Instance = Class1.new
      Instance.some_configuration.should == [ :some_other_value ]
      Instance.some_configuration.push( :some_value )
      Instance.some_configuration.should == [ :some_other_value, :some_value ]
      Instance.some_configuration = [ :some_other_value ]
      Instance.some_configuration.should == [ :some_other_value ]
    
    end
  end
  
end

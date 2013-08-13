# -*- encoding : utf-8 -*-

module ::CascadingConfiguration::Controller

  include ::CascadingConfiguration::Controller::Configurations
  include ::CascadingConfiguration::Controller::HasConfigurations
  include ::CascadingConfiguration::Controller::Register
  include ::CascadingConfiguration::Controller::Unregister
  include ::CascadingConfiguration::Controller::Replace
  include ::CascadingConfiguration::Controller::Share
  include ::CascadingConfiguration::Controller::Events
  include ::CascadingConfiguration::Controller::Methods

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( instance )
    
    super if defined?( super )
    
    instance.instance_eval do
      @active_configurations = { }
      @singleton_configurations = { }
      @instance_configurations = { }
      @object_configurations = { }
      @local_instance_configurations = { }
      @objects_sharing_singleton_configurations = { }
      @objects_sharing_instance_configurations = { }
      @objects_sharing_object_configurations = { }
      @read_method_modules = { }
      @write_method_modules = { }

      const_set( :ReadMethodModules, ::Module.new )
      const_set( :WriteMethodModules, ::Module.new )
    end
    
  end

  ##############
  #  extended  #
  ##############
  
  ###
  # Extend causes all defined cascading configuration modules to be extended.
  #
  def extended( instance )
    
    super if defined?( super )
    
    configuration_modules.each { |this_member| instance.extend( this_member ) }
    
  end
    
end

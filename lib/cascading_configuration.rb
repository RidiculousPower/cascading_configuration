
begin ; require 'development' ; rescue ::LoadError ; end

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

# any post-require setup
require_relative './setup.rb'

module ::CascadingConfiguration
  
  ConfigurationModules = [ Setting, 
                           Hash, 
                           Array,
                           Array::Unique,
                           Array::Sorted,
                           Array::Sorted::Unique ]
  
  ###################
  #  self.included  #
  ###################
  
  def self.included( instance )
    
    super if defined?( super )
    
    instance.module_eval do
      ::CascadingConfiguration::ConfigurationModules.each do |this_member|
        include( this_member )
      end
    end
    
  end

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( instance )
    
    super if defined?( super )
    
    ::CascadingConfiguration::ConfigurationModules.each do |this_member|
      instance.extend( this_member )
    end
    
  end
  
  ##########################
  #  self.register_parent  #
  ##########################
  
  ###
  # Runs #register_parent_for_configuration for each configuration in parent.
  #
  #
  def self.register_parent( child, parent, encapsulation_or_name = :default )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    return encapsulation.register_parent( child, parent )
    
  end

  ############################################
  #  self.register_parent_for_configuration  #
  ############################################
  
  def self.register_parent_for_configuration( child, parent, configuration_name, encapsulation_or_name = :default )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    return encapsulation.register_parent_for_configuration( child, parent, configuration_name )
    
  end

  #########################
  #  self.replace_parent  #
  #########################
  
  def self.replace_parent( child, parent, new_parent, encapsulation_or_name = :default )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    return encapsulation.replace_parent( child, parent, new_parent )
    
  end

  ###########################################
  #  self.replace_parent_for_configuration  #
  ###########################################
  
  def self.replace_parent_for_configuration( child, parent, configuration_name, encapsulation_or_name = :default )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    return encapsulation.replace_parent_for_configuration( child, parent, configuration_name)
    
  end

  ##########################################
  #  self.remove_parent_for_configuration  #
  ##########################################
  
  def self.remove_parent_for_configuration( child, parent, configuration_name, encapsulation_or_name = :default )
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( encapsulation_or_name )
    
    return encapsulation.remove_parent_for_configuration( child, parent, configuration_name )
    
  end
    
end

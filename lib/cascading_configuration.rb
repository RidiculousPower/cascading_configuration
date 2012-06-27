
# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

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
  
end

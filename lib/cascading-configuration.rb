
require 'to_camel_case'
require 'accessor-utilities'
require 'parallel-ancestry'
require 'compositing-hash'
require 'compositing-array-sorted-unique'

module ::CascadingConfiguration
  module Core
    class InstanceController < ::Module
      module Methods
      end
    end
  end
end

basepath = 'cascading-configuration/CascadingConfiguration'

files = [
    
  'Core/EnableModuleSupport',
  'Core/EnableInstanceSupport',
  
  'Core',
  
  'Core/Encapsulation',
  
  'Core/Module',
  'Core/Module/InheritingValues',
  'Core/Module/ExtendedConfigurations',
  'Core/Module/ExtendedConfigurations/CompositingObjects',
  'Core/Module/BlockConfigurations',
  'Core/Module/BlockConfigurations/CascadingVariables',
    
  'Core/InstanceController/Methods/InstanceMethods',
  'Core/InstanceController/Methods/LocalInstanceMethods',
  'Core/InstanceController/Methods/SingletonAndInstanceMethods',
  'Core/InstanceController/Methods/SingletonMethods',
  'Core/InstanceController/Methods',
  'Core/InstanceController/SupportModule',
  'Core/InstanceController/ExtensionModule',
  'Core/InstanceController',
  
  'Setting',
  
  'Hash',
  
  'Array',
  'Array/Unique',
  'Array/Sorted',
  'Array/Sorted/Unique'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )

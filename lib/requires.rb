require 'to_camel_case'
require 'accessor-utilities'
require 'parallel-ancestry'
require 'compositing-hash'
require 'compositing-array-sorted-unique'

#require_relative '../../compositing_objects/compositing-hash/lib/compositing-hash.rb'

basepath = 'cascading_configuration'

files = [
    
  'core/enable_module_support',
  'core/enable_instance_support',
  
  'core',
  
  'core/encapsulation',
  
  'core/module',
  'core/module/inheriting_values',
  'core/module/extended_configurations',
  'core/module/extended_configurations/compositing_objects',
  'core/module/block_configurations',
  'core/module/block_configurations/cascading_variables',
    
  'core/instance_controller/support_module',
  'core/instance_controller/support_module/instance_support_module',
  'core/instance_controller/support_module/singleton_support_module',
  'core/instance_controller/extension_module',
  'core/instance_controller',
  
  'setting',
  
  'hash',
  
  'array',
  'array/unique',
  'array/sorted',
  'array/sorted/unique'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

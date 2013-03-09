# -*- encoding : utf-8 -*-

require 'to_camel_case'
require 'accessor_utilities'
require 'parallel_ancestry'
require 'hash'
require 'array'

require_relative 'cascading_configuration_modules'

basepath = 'cascading_configuration'

files = [
  
  'object_with_configurations',
  
  'include_creates_instance_support',
  
  'configuration_hash',
  
  'module',
  'module/configuration',
  'module/configuration/class_configuration',
  'module/configuration/class_instance_configuration',
  'module/configuration/class_inheriting_from_module_configuration',
  'module/configuration/module_configuration',
  'module/configuration/instance_configuration',
  'module/cascading_settings',
  'module/cascading_settings/configuration',
  'module/block_configurations',
  'module/block_configurations/cascading_values',
  'module/block_configurations/cascading_values/configuration',
  'module/block_configurations/extendable_configurations',
  'module/block_configurations/extendable_configurations/configuration',
  'module/block_configurations/extendable_configurations/compositing_objects',
  'module/block_configurations/extendable_configurations/compositing_objects/configuration',
  'module/block_configurations/extendable_configurations/compositing_objects/array',
  'module/block_configurations/extendable_configurations/compositing_objects/array/configuration',
  'module/block_configurations/extendable_configurations/compositing_objects/hash',
  'module/block_configurations/extendable_configurations/compositing_objects/hash/configuration',
    
  'instance_controller/support_module',
  'instance_controller/support_module/instance_support_module',
  'instance_controller/support_module/singleton_support_module',
  'instance_controller/support_module/local_instance_support_module',
  'instance_controller/extension_module',
  'instance_controller',
  
  'value',

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

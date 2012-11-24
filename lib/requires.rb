
begin ; require 'development' ; rescue ::LoadError ; end

require 'to_camel_case'
require 'accessor_utilities'
require 'parallel_ancestry'
require 'hash'
require 'array'

basepath = 'cascading_configuration'

files = [
    
  'core/include_creates_instance_support',

  'core',
  
  'core/auto_nesting_id_hash',
  
  'core/module',
  'core/module/configuration',
  'core/module/configuration/class_configuration',
  'core/module/configuration/class_instance_configuration',
  'core/module/configuration/module_configuration',
  'core/module/configuration/instance_configuration',
  'core/module/inheriting_values',
  'core/module/inheriting_values/configuration',
  'core/module/block_configurations',
  'core/module/block_configurations/cascading_variables',
  'core/module/block_configurations/extendable_configurations',
  'core/module/block_configurations/extendable_configurations/compositing_objects',
  'core/module/block_configurations/extendable_configurations/compositing_objects/configuration',
  'core/module/block_configurations/extendable_configurations/compositing_objects/array',
  'core/module/block_configurations/extendable_configurations/compositing_objects/array/configuration',
  'core/module/block_configurations/extendable_configurations/compositing_objects/hash',
  'core/module/block_configurations/extendable_configurations/compositing_objects/hash/configuration',
    
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

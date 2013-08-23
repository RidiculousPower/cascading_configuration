# -*- encoding : utf-8 -*-

[

  'cascading_configuration/parallel_ancestry',

  'cascading_configuration/read_method_module',
  'cascading_configuration/write_method_module',
  
  'cascading_configuration/controller/configurations',
  'cascading_configuration/controller/has_configurations',
  'cascading_configuration/controller/register',
  'cascading_configuration/controller/unregister',
  'cascading_configuration/controller/replace',
  'cascading_configuration/controller/share',
  'cascading_configuration/controller/events',
  'cascading_configuration/controller/methods',
  'cascading_configuration/controller',

  'cascading_configuration/object_with_configurations',
  
  'cascading_configuration/configuration_hash',
  'cascading_configuration/configuration_hash/inactive_configurations',
  'cascading_configuration/configuration_hash/inactive_configurations/instance_configurations',
  'cascading_configuration/configuration_hash/inactive_configurations/object_configurations',
  'cascading_configuration/configuration_hash/active_configurations',
  'cascading_configuration/configuration_hash/singleton_configurations',
  'cascading_configuration/configuration_hash/instance_configurations',
  
  'cascading_configuration/module',
  'cascading_configuration/module/configuration',
  'cascading_configuration/module/configuration/extension_module',
  'cascading_configuration/module/configuration/class_configuration',
  'cascading_configuration/module/configuration/class_instance_configuration',
  'cascading_configuration/module/configuration/class_inheriting_from_module_configuration',
  'cascading_configuration/module/configuration/module_configuration',
  'cascading_configuration/module/configuration/instance_configuration',
  'cascading_configuration/module/cascading_settings',
  'cascading_configuration/module/cascading_settings/configuration',
  'cascading_configuration/module/block_configurations',
  'cascading_configuration/module/block_configurations/configuration',
  'cascading_configuration/module/block_configurations/cascading_values',
  'cascading_configuration/module/block_configurations/cascading_values/configuration',
  'cascading_configuration/module/block_configurations/extendable_configurations',
  'cascading_configuration/module/block_configurations/extendable_configurations/configuration',
  'cascading_configuration/module/block_configurations/extendable_configurations/compositing_objects',
  'cascading_configuration/module/block_configurations/extendable_configurations/compositing_objects/configuration',
  'cascading_configuration/module/block_configurations/extendable_configurations/compositing_objects/array',
  'cascading_configuration/module/block_configurations/extendable_configurations/compositing_objects/array/configuration',
  'cascading_configuration/module/block_configurations/extendable_configurations/compositing_objects/hash',
  'cascading_configuration/module/block_configurations/extendable_configurations/compositing_objects/hash/configuration',

  'cascading_configuration/value',
  'cascading_configuration/setting',
  'cascading_configuration/hash',  
  'cascading_configuration/array',
  'cascading_configuration/array/unique',
  'cascading_configuration/array/sorted',
  'cascading_configuration/array/sorted/unique'
    
].each { |this_file| require_relative( this_file << '.rb' ) }

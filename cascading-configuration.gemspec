require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'cascading-configuration'
  spec.rubyforge_project         =  'cascading-configuration'
  spec.version                   =  '2.0.0'

  spec.summary                   =  "Adds methods for cascading configurations."
  spec.description               =  "Provides :attr_configuration,  :attr_configuration_array, and :attr_configuration_hash."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/cascading-configuration'

  spec.add_dependency            'module-cluster'

  spec.add_dependency            'cascading-configuration-setting'
  spec.add_dependency            'cascading-configuration-array'
  spec.add_dependency            'cascading-configuration-hash'

  spec.date                      =  Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*' ]

end

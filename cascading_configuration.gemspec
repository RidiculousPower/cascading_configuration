require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'cascading_configuration'
  spec.rubyforge_project         =  'cascading_configuration'
  spec.version                   =  '1.0.3'

  spec.summary                   =  "Provides inheritable values across Ruby inheritance hierarchy or across arbitrary declared inheritance relations."
  spec.description               =  "Inheritable Objects and Downward-Compositing Hashes and Arrays; Downward-Transforming Values coming soon."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/cascading_configuration'

  spec.required_ruby_version     = ">= 1.9.1"

  spec.add_dependency            'module-cluster'
  spec.add_dependency            'to_camel_case'
  spec.add_dependency            'accessor_utilities'
  spec.add_dependency            'parallel_ancestry'
  spec.add_dependency            'hash'
  spec.add_dependency            'array'

  spec.date                      = Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end

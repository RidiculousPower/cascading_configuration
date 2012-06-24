require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'cascading-configuration'
  spec.rubyforge_project         =  'cascading-configuration'
  spec.version                   =  '3.0.4'

  spec.summary                   =  "Provides inheritable values across Ruby inheritance hierarchy or across arbitrary declared inheritance relations."
  spec.description               =  "Inheritable Objects and Downward-Compositing Hashes and Arrays; Downward-Transforming Values coming soon."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/cascading-configuration'

  spec.add_dependency            'module-cluster'
  spec.add_dependency            'to_camel_case'
  spec.add_dependency            'accessor-utilities'
  spec.add_dependency            'parallel-ancestry'
  spec.add_dependency            'compositing-hash'
  spec.add_dependency            'compositing-array-sorted-unique'

  spec.date                      = Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end

require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'cascading-configuration'
  spec.rubyforge_project         =  'cascading-configuration'
  spec.version                   =  '1.0.0'

  spec.summary                   =  "Adds methods for cascading configurations to Class and object instances."
  spec.description               =  "Provides :get_cascading_hash_downward_from_Object,  :get_cascading_array_downward_from_Object, and :get_configuration_searching_upward_from_self."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/cascading-configuration'

  spec.date                      =  Date.today.to_s
  
  # ensure the gem is built out of versioned files
  # also make sure we include the bundle since we exclude it from git storage
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*' ] & `git ls-files -z`.split("\0")

end

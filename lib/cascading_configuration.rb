# -*- encoding : utf-8 -*-

require 'to_camel_case'
require 'accessor_utilities'
require 'singleton_attr'
require 'hash'
require 'array'
require 'parallel_ancestry'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces.rb'

require_relative './cascading_configuration_modules.rb'

module ::CascadingConfiguration
  extend ::CascadingConfiguration::Modules
end

# source file requires
require_relative './requires.rb'

module ::CascadingConfiguration
  extend ::CascadingConfiguration::Controller
end

require_relative '../lib_ext/parallel_ancestry.rb'

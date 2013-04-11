# -*- encoding : utf-8 -*-

require 'forwardable'
require 'to_camel_case'
require 'accessor_utilities'
require 'parallel_ancestry'
require 'hash'
require 'array'
require 'singleton_attr'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

require_relative 'cascading_configuration_modules'

module ::CascadingConfiguration
  extend ::CascadingConfiguration::Modules
end

# source file requires
require_relative './requires.rb'

module ::CascadingConfiguration
  extend ::CascadingConfiguration::Controller
end


module CascadingConfiguration
  
  extend ModuleCluster::Define::Cluster
  
  include_also_includes( CascadingConfiguration::Setting, 
                         CascadingConfiguration::Array,
                         CascadingConfiguration::Array::Unique,
                         CascadingConfiguration::Array::Sorted,
                         CascadingConfiguration::Array::Sorted::Unique,
                         CascadingConfiguration::Hash )
  
  extend_also_extends( CascadingConfiguration::Setting,
                       CascadingConfiguration::Array,
                       CascadingConfiguration::Array::Unique,
                       CascadingConfiguration::Array::Sorted,
                       CascadingConfiguration::Array::Sorted::Unique,
                       CascadingConfiguration::Hash )
  
end

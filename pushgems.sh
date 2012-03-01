
ROOTDIR=$PWD
GEMS=$ROOTDIR/gems/

cd $GEMS

gem push cascading-configuration-setting-*.gem
gem push cascading-configuration-array-*.gem
gem push cascading-configuration-array-unique-*.gem
gem push cascading-configuration-array-sorted-*.gem
gem push cascading-configuration-array-sorted-unique-*.gem
gem push cascading-configuration-hash-*.gem
gem push cascading-configuration-variable-*.gem

cd $ROOTDIR

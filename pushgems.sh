
ROOTDIR=$PWD
GEMS=$ROOTDIR/gems/

MAJOR_VERSION=2

cd $GEMS

gem push cascading-configuration-setting-${MAJOR_VERSION}*.gem
gem push cascading-configuration-array-${MAJOR_VERSION}*.gem
gem push cascading-configuration-array-unique-${MAJOR_VERSION}*.gem
gem push cascading-configuration-array-sorted-${MAJOR_VERSION}*.gem
gem push cascading-configuration-array-sorted-unique-${MAJOR_VERSION}*.gem
gem push cascading-configuration-hash-${MAJOR_VERSION}*.gem
gem push cascading-configuration-ancestors-${MAJOR_VERSION}*.gem
gem push cascading-configuration-inheritance-${MAJOR_VERSION}*.gem
gem push cascading-configuration-methods-${MAJOR_VERSION}*.gem
gem push cascading-configuration-variable-${MAJOR_VERSION}*.gem

cd $ROOTDIR

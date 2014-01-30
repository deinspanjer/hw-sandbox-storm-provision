#!/bin/sh

# based on https://github.com/purple52/librarian-puppet-vagrant

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/
if [ ! -d "$PUPPET_DIR" ]; then
  mkdir -p $PUPPET_DIR
fi

cp puppet/Puppetfile $PUPPET_DIR

# Using patched version of librarian-puppet. See:
# http://blog.csanchez.org/2013/01/24/managing-puppet-modules-with-librarian-puppet/
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi



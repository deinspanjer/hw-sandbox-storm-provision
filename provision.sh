#!/bin/sh

PUPPET_DIR=/etc/puppet/
if [ ! -d "$PUPPET_DIR" ]; then
  mkdir -p $PUPPET_DIR
fi


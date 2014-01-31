#!/bin/sh

if [ ! -f /etc/yum.repos.d/puppetlabs.repo ]
then
    sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm
    yum makecache
    sed -i 's/enabled=1/&\npriority=1/' /etc/yum.repos.d/puppetlabs.repo
    yum update -y puppet
    puppet module install puppetlabs/java
    touch /etc/puppet/hiera.yaml
fi

PUPPET_MODULE_PATH=$(puppet config print modulepath):$(pwd)/puppet/modules

puppet apply --modulepath="$PUPPET_MODULE_PATH" puppet/manifests/default.pp

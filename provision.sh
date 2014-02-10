#!/bin/sh

# Only update puppet and install modules once.
if [ ! -f /etc/yum.repos.d/puppetlabs.repo ]
then
    # Add PuppetLabs repo
    sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm

    # Ensure packages in the PuppetLabs repo are visible
    yum makecache

    # Hack the priority of PuppetLabs repo so their packages can be installed too
    sed -i 's/enabled=1/&\npriority=1/' /etc/yum.repos.d/puppetlabs.repo

    yum update -y puppet

    puppet module install puppetlabs-java

    # The concat plugin that is available in forge.puppetlabs.com has a bug we don't want.
    git clone git://github.com/puppetlabs/puppetlabs-concat /etc/puppet/modules/concat

    # Not using hiera, but don't want warnings.
    touch /etc/puppet/hiera.yaml

    # Update module path to include our local modules
    PUPPET_MODULE_PATH=$(puppet config print modulepath):$(pwd)/puppet/modules
fi

# Do the fun stuff.  Install and configure Storm as well as clean up a few issues with the VM
puppet apply --modulepath="$PUPPET_MODULE_PATH" puppet/manifests/default.pp $@

# Quick fix to get storm into the path for the current ssh session
. /etc/profile.d/storm-path.sh

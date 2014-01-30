# Puppet provisioning project to add Storm and Kettle-Storm to Hortonworks Sandbox 2.0 VM

Hortonworks has a long detailed document on how to add Storm to their Sandbox VM ( http://hortonworks.com/blog/storm-technical-preview-available-now/ ).

This project automates that process plus the process of installing the Pentaho Kettle-Storm project.

## Getting started

Requirements:

The Hortonworks Sandbox 2.0 (virtualbox version) : http://hortonworks.com/products/hortonworks-sandbox/

The Sandbox VM should be running and configured with internet access.

## To provision the VM:

1. Log into the VM via SSH (i.e. putty on Windows) as instructed on the VM's splash screen.
1. Run these commands:
    $ git clone git@github.com:deinspanjer/hw-sandbox-storm-provision.git
	$ cd hw-sandbox-storm-provision
    $ chmod u+x provision.sh
	$ ./provision.sh
    
## To try out the Storm Starter sample topologies (jobs):
    $ TODO

## To try out the Kettle-Storm sample transformation:
    $ TODO

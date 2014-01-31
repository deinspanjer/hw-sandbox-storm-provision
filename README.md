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
  # git clone git@github.com:deinspanjer/hw-sandbox-storm-provision.git
	# cd hw-sandbox-storm-provision
	# ./provision.sh
1. When the provisioning is done, you should be able to tail the storm logs:
	# tail -F /var/log/storm/*
1. The last step is to set up port forwarding for the two new HTTP ports.
    1. Open the VirtualBox application
		1. Select the Hortonworks Sandbox 2.0 VM from the list on the left
		1. Click the Settings button on the toolbar
		1. Click the Network icon on the Settings dialog toolbar
		1. Under the Advanced section for Adapter 1, click Port Forwarding
		1. Click the + button to add a new port forward
		1. Name: storm-ui; Host Port: 8880; Guest Port: 8880
		1. Click the + button again to add a new port forward
		1. Name: storm-logviewer; Host Port: 8881; Guest Port: 8881
1. Visit the Storm Nimbus UI: http://localhost:8880/

## To try out the Storm Starter sample topologies (jobs):
    $ TODO

## To try out the Kettle-Storm sample transformation:
    $ TODO

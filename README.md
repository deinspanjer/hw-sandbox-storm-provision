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
```
# cd hw-sandbox-storm-provision
# ./provision.sh
```
1. When the provisioning is done, you should be able to tail the storm logs:
```
# tail -F /var/log/storm/*
```
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

1. Since this transformation uses twitter4j, you must set up credentials for the demo.
    1. Create app and access token
        1. Log in to the Twitter Dev site:  https://apps.twitter.com/
        1. Click the "Create New App button"
        1. Fill out the "Application details" form.
            1. The contents of this form are not important for the demo.
            1. You can leave the "Callback URL" field blank.
        1. Click the "Create your Twitter application" button.
        1. On the "Application Mangement" page for your newly created app, click the "manage API keys" link under "Application settings" / "API key"
        1. On the "API Keys" page, click the "Create my access token" button at the bottom.
        1. Wait a few moments, then refresh the page to see your access token.
    1. Edit twitter4j.properties file
        1. In the hw-sandbox-storm-provision directory of your VM, edit the twitter4j.properties file
        1. Copy each of the four values from the Twitter App API Keys page into this file:
            1. API key == "oath.consumerKey"
            1. API secret == "oath.consumerSecret"
            1. Access token == "oath.accessToken"
            1. Access token secret == "oath.accessTokenSecret"
    1. Add the modified twitter4j.properties file to the jar so it can be found in the classpath
        1. In the hw-sandbox-storm-provision directory of your VM, run this command:

    jar uf kettle-engine-storm-0.0.2-SNAPSHOT-for-remote-topology.jar twitter4j.properties
    1. Submit the jar to the Storm cluster, passing in the Kettle transformation to run

    storm jar kettle-engine-storm-0.0.2-SNAPSHOT-for-remote-topology.jar org.pentaho.kettle.engines.storm.KettleStorm demo-twitter4j.ktr
    1. By default, the transformation will run for 15 seconds then automatically shut down.
    1. View the results in the output text file

    cat /home/storm/tweets.txt
1. Optionally, modify the duration or change the filter keywords by editing the demo-twitter4j.ktr

# jenkins-docker-in-docker

Run Jenkins in a multinode VM cluster (using Multipass). Jenkin jobs will create a new container to run the job as opposed to on VM, hence docker in docker. 

This is all done on a local Windows machine using Docker Desktop

# Requirements

 1. [Docker Desktop](https://www.docker.com/products/docker-desktop)
 2. [Multipass](https://Multipass.run/)
 3. Powershell

# Multipass Setup

In the Multipass directory there is a `cloud-config.yml` file that is the configuration for creating a Multipass VM with docker installed. There is also a `run.ps1` file that contains the Multipass commands to spin up the VMs and also setup a volume mount for persisting the jenkins_home directory. You will need to set the `JENKINS_HOME` environment variable on your system with any location where you want jenkins_home to be stored. 

On Windows we will need to [enable Multipass mounts](https://multipass.run/docs/set-command#local.privileged-mounts)

`multipass set local.privileged-mounts=true`

Run the `run.ps1` file to start the Multipass VMs. This will setup three Ubuntu VMs with docker installed

`.\multipass\run.ps1`

Check that the VMs are running

`multipass ls`

Enter the shell of the VM

`multipass exec jenkins-docker-in-docker-node1 -- bash`

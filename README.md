# jenkins-docker-in-docker

Run Jenkins in a multinode VM cluster (using multipass). Any Jenkin job runs will create a new container to run the job as opposed to on VM. Hence docker in docker. 

This is all done on a local Windows machine using Docker Desktop

# Requirements

 Markup : 1. Docker Dekstop (https://www.docker.com/products/docker-desktop)
          2. Multipass (https://multipass.run/)
          3. Powershell

# Multipass Setup

Verify that your multipass setup is installed correctly.
`multipass --version`




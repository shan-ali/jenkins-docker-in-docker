# jenkins-docker-in-docker

Run Jenkins in a Docker container. Jenkins jobs will create a new temporary sibling Docker container with the help of the [Docker Pipeline Plugin](https://github.com/jenkinsci/docker-workflow-plugin) to execute the job. Hence Docker in Docker.

# Requirements

This is all done on a local Windows machine using [Docker Desktop](https://www.docker.com/products/docker-desktop)

# Setup Container

### Running Jenkins
```
docker run -u root --name jenkins -d -p 8080:8080 -p 50000:50000
-v jenkins_home:/var/jenkins_home 
-v //var/run/docker.sock:/var/run/docker.sock 
-v //usr/bin/docker:/usr/bin/docker  
--pull=always shanali38/jenkins-docker-in-docker
```

More information about Jenkins in Docker can be found in the [Official Jenkins Docker Image Source](
https://github.com/jenkinsci/docker/blob/master/README.md)

### Image on Docker Hub

https://hub.docker.com/repository/docker/shanali38/jenkins-docker-in-docker

### Mounting Docker Unix Socket & Docker Executable

["The Docker daemon listens to a socket at /var/run/docker.sock, responding to calls to the Docker API. If we want to be able to issue Docker commands from a container, we’ll need to communicate with this socket."](https://tomgregory.com/running-docker-in-docker-on-windows/#All_about_varrundockersock) Therefore, we can avoid having to reinstall Docker on the Jenkins container, and instead use the Docker installation on the host (in our case, our local Windows host running Docker Desktop). More importantly, this will allow Jenkins to spawn new containers on the host machine, rather than in itself. 

```
-v //var/run/docker.sock:/var/run/docker.sock
```

We will also need to mount the docker executable from the host.

```
-v //usr/bin/docker:/usr/bin/docker
```
 
### Docker Unix Socket Permissions

By default `/var/run/docker.sock` should be owned by `root:docker` (or `root:jenkins`) meaning that in order to access the Docker socket your user needs to be in the docker group. However, when using Docker Desktop `/var/run/docker.sock` will be instead owned by `root:root`. To get around this we will need to run the container as root. Keep in mind that this is not ideal for Production scenerios. 

```
-u root
```

If running on a linux host `/var/run/docker.sock` should have the correct permissions of root:docker (or root:jenkins) and we do not have to run the container as root.

### Persisting Jenkins Home

`/var/jenkins_home` stores all of the configuration for the Jenkins instance. In order to persist our installation we will want to mount this location to a Docker volume. More elgant solutions should be implemented to backup and store jenkins_home for long term usage.  

```
-v jenkins_home:/var/jenkins_home
```

# Dockerfile

In the Dockerfile for this Jenkins image there are two custom steps

### Pre Install Suggested Plugins

jenkins/plugins.txt contains all the plugins we want to install and their versions. This list contains all the suggested plugins when you are first setting up Jenkins + the Docker Pipeline Plugin (docker-workflow:1.28) 

```
COPY --chown=jenkins:jenkins jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
```

### Create an Example Build Job

jenkins/jobs/jenkins-docker-in-docker-build/config.xml is the config file for a Jenkins build job that will built this repos docker image. We will copy this into jenkins_home so that on initital startup we will have the `jenkins-docker-in-docker-build` job already made.

```
COPY --chown=jenkins:jenkins jenkins/jobs/ /var/jenkins_home/jobs/
```

# Setup Jenkins

You can access the Jenkins instance by going to http://localhost:8080/. You will need to go through the initial setup

### Unlock Jenkins

We can get easily get the Jenkins initial admin password with the following
```
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Customize Jenkins
Click on "Install Suggested Plugins". Since we already did this via `plugins.txt`, all the suggested plugins should already be installed. 

### Create First Admin User
Create your first admin user or skip and use the "admin" user with the initial admin password that you retrieved from `/var/jenkins_home/secrets/initialAdminPassword`. In a production Jenkins setup you will want to use a more robust user management system like LDAP or any of the other offerings in Jenkins. 

# Running the Build Job

The job [jenkins-docker-in-docker-build](http://localhost:8080/job/jenkins-docker-in-docker-build/) is a pipeline job that uses the `Jenkinsfile` in this repository to execute a docker build using the `Dockerfile` in the docker directory in this repository. Essentially, we are just building the same image that we are currently running. However, this job will create a new Docker container to execute the build rather than running it on the Jenkins container itself. Once it completes all of the steps, the newly created container will be deleted. 

https://user-images.githubusercontent.com/16169323/153267994-7b27dec5-429f-4452-af8f-81016846e71d.mp4

# References
- https://github.com/jenkinsci/docker/blob/master/README.md
- https://tomgregory.com/running-docker-in-docker-on-windows
- https://tomgregory.com/running-docker-in-docker-on-windows
- https://gist.github.com/afloesch/ea855b30cfb9f157dda8c207d40f05c0
- https://github.com/jenkinsci/docker-workflow-plugin
- https://stackoverflow.com/questions/47854463/docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socke?page=1&tab=votes#tab-top

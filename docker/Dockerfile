#FROM jenkins/jenkins:2.319.2-lts-jdk11
FROM jenkins/jenkins:lts-alpine-jdk11

USER root

# create a docker group and add the jenkins user to it
# this is needed so that the jenkins user can run docker commands
RUN addgroup docker && addgroup jenkins docker

USER jenkins

# copy plugins list and install them
COPY --chown=jenkins:jenkins jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# copy initial build job as an example
COPY --chown=jenkins:jenkins jenkins/jobs/ /var/jenkins_home/jobs/

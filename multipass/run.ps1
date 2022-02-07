#start vms
multipass launch --cloud-init ./multipass/cloud-config.yml --disk 10G --mem 2G --cpus 1 --name jenkins-docker-in-docker-node1
multipass launch --cloud-init ./multipass/cloud-config.yml --disk 5G --mem 2G --cpus 1 --name jenkins-docker-in-docker-node2
multipass launch --cloud-init ./multipass/cloud-config.yml --disk 5G --mem 2G --cpus 1 --name jenkins-docker-in-docker-node3

#setup volume mount for jenkins_home
multipass mount $env:JENKINS_HOME jenkins-docker-in-docker-node1:/var/jenkins_home

pipeline {
  agent {
    docker {
      image 'docker:20.10.12-git'
    }
  }
  stages {
    stage('Build') {
        steps {
            echo 'Building...'
            sh "docker image build -t shanali38/jenkins-docker-in-docker -f docker/Dockerfile ."
        }
    }
    stage('Test') {
        steps {
            echo 'Testing..'
            sh "docker image ls"
        }
    }
    stage('Deploy') {
        steps {
            echo 'Deploying....'
        }
    }
  }
}
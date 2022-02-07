pipeline {
  agent {
    docker {
      image 'docker:20.10.12-git'
    }
  }
  stages {
    stage('Get Docker Version') {
      steps {
        sh "docker --version"
      }
    }
    stage('Get Git Version') {
      steps {
        sh "git --version"
      }
    }
  }
}
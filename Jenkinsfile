pipeline {
  agent {
    docker {
      image 'maven:3.8.4-jdk-11'
    }
  }
  stages {
    stage('Get Maven Version') {
      steps {
        sh "mvn --version"
      }
    }
  }
}
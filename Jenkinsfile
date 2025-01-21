podTemplate(
  agentContainer: 'jnlp',
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'jenkins/inbound-agent',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker:latest',
      command: 'sleep',
      args: '99d',
      ttyEnabled: true,
      privileged: true,
      volumeMounts: [
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
      ]
    ),
    containerTemplate(
      name: 'docker-daemon',
      image: 'docker:dind',
      command: 'dockerd',
      ttyEnabled: true,
      privileged: true,
      volumeMounts: [
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
      ]
    )
  ]
) {
  pipeline {
    environment {
      DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
      stage('Code Clone') {
        steps {
          checkout scm
        }
      }
      stage('Docker Operations') {
        steps {
          container('docker') {
            sh 'docker --version'
            sh 'docker ps'
          }
        }
      }
    }
  }
}

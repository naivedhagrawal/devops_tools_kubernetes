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
  node(POD_LABEL) {
    environment {
      DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stage('Code Clone') {
      checkout scm
    }
    stage('Docker Operations') {
      container('docker') {
        sh 'docker --version'
        sh 'docker ps'
      }
    }
  }
}

podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true,),
    containerTemplate(name: 'docker', image: 'docker:latest', command: 'cat', ttyEnabled: true, privileged: true, volumeMounts: [hostPathVolume(mountPath: '/var/run', hostPath: '/var/run')]),
  ]) {
    node(POD_LABEL) {
        environment {
            DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
        }

        stage('Code Clone') {
            checkout scm
        }

        stage('docker') {
            container('docker') {
                sh 'docker --version'
                sh 'echo $USER'
                sh 'docker ps'
            }
        }
    }
  }

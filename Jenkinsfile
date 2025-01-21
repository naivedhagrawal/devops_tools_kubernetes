podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true, runAsUser: '0'),
    containerTemplate(name: 'docker', image: 'docker:latest', command: 'cat', ttyEnabled: true, runAsUser: '0')
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
                sh 'docker ps'
            }
        }
    }
  }

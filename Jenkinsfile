podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', command: 'cat', ttyEnabled: true),
    containerTemplate(
        name: 'docker',
        image: 'docker:latest',
        readinessProbe: [execCommand: ['sh', '-c', 'ls -S /var/run/docker.sock']],
        initialDelaySeconds: 5,
        periodSeconds: 5,
        command: 'sleep',
        args: '99d',
        ttyEnabled: true,
        privileged: true,
        volumeMounts: [hostPathVolume(mountPath: '/var/run', hostPath: '/var/run')]),
    containerTemplate(
        name: 'docker-daemon',
        image: 'docker:dind',
        command: 'dockerd',
        ttyEnabled: true,
        privileged: true,
        volumeMounts: [hostPathVolume(mountPath: '/var/run', hostPath: '/var/run')]),
  ]) {
                sh 'whoami'
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

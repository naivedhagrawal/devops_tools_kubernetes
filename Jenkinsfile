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
      readinessProbe: [
        execCommand: ['sh', '-c', 'ls -S /var/run/docker.sock'],
        initialDelaySeconds: 5,
        periodSeconds: 5
      ]
    ),
    containerTemplate(
      name: 'docker-daemon',
      image: 'docker:dind',
      command: 'dockerd',
      ttyEnabled: true,
      privileged: true,
      volumeMounts: [
        hostPathVolume(mountPath: '/var/run', hostPath: '/var/run')
      ]
    )
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run', hostPath: '/var/run')
  ]
) {
  node(POD_LABEL) {
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

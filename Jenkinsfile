podTemplate(
  agent { 
    Kubernetes{
        inheritFrom 'all-in-one'
    }
}
)

{
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

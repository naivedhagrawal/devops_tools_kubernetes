Jenkinsfile (Scripted Pipeline)
node {
    stage('Build') {
        sh 'make' 
        archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
    }
}
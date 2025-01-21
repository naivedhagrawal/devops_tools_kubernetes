pipeline {
    agent { label 'jnlp' }
    stages {
        stage('Code Clone') {
            steps {
                checkout scm
            }
        }
        
        stage('Docker Operations') {
            steps {
                sh 'docker --version'
                sh 'docker ps'
        }
    }
}
}
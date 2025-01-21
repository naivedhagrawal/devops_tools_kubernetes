pipeline {
    agent all-in-one
    stages {
        stage('Code Clone') {
            steps {
                checkout scm
            }
        }
        
        stage('Docker Operations') {
            steps {
                sh 'maven --version'
                sh 'docker --version'
                sh 'docker ps'
            }
        }
    }
}
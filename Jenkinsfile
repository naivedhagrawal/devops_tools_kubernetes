pipeline {
    agent any
    stages {
        stage('Code Clone') {
            steps {
                checkout scm
            }
        }
        stage('Docker Operations') {
            agent {
                docker {
                    image 'docker:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'docker --version'
                sh 'docker ps'
            }
        }
    }
}
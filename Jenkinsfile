pipeline {
    agent any
    stages {
        stage('Code Clone') {
            steps {
                checkout scm
            }
        }
        stage('Docker Operations') {
            sh 'docker --version'
                }
            steps {
                sh 'docker --version'
                sh 'docker ps'
            }
        }
    }
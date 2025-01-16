/* groovylint-disable-next-line CompileStatic */
pipeline {
    /* groovylint-disable-next-line SpaceAfterClosingBrace */
    agent { kubernetes { yamlFile 'pod.yaml' } }
    stages {
        stage('Build') {
            steps {
                sh 'make'
            }
        }
        stage('Test'){
            steps {
                sh 'make check'
                junit 'reports/**/*.xml'
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish' //
            }
        }
    }
}

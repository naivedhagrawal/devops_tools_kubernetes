pipeline {
    /* groovylint-disable-next-line SpaceAfterClosingBrace */
    agent { kubernetes { yamlFile 'pod.yaml' } }

    stages {
        stage('build') {
            steps {
                sh 'node --version'
            }
        }
    }
}
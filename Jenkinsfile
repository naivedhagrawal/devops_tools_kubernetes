node {
    stage('Build') {
        docker.image('maven:3.9.9-eclipse-temurin-21-alpine').inside {
            sh 'mvn --version'
        }
    }
}
podTemplate(
  agentContainer: 'jnlp',
  agentInjection: true,
  showRawYaml: false,
  containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent:latest', alwaysPullImage: true, privileged: true),
    containerTemplate(name: 'all-in-one', image: 'naivedh/jenkins-agent-all-in-one:latest',alwaysPullImage: true, command: 'cat', ttyEnabled: true)
  ])
{
    node(POD_LABEL) {
        stage('Buid') {
            container('all-in-one') {
              sh "docker build -t myapp:latest ."
              sh "docker images"
            }
        }
    }
}
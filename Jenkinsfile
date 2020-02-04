pipeline {
  
  agent any 
  environment {
    DOCKER_TAG = getDockerTag()
  }
  
  stages {
    stage('Build Docker Image'){
      steps{
        sh "sudo su"
        sh "docker build . -t mbhaskar2005/firstdockerrepo:${DOCKER_TAG}"
        }
     }

    stage('DockerHub Push'){
      steps{
        sh "docker images"
        withCredentials([string(credentialsId: 'dockerPWD', variable: 'DockerPWD')]) {
          sh "docker login -u mbhaskar2005 -p ${DockerPWD}"
          sh "docker push mbhaskar2005/firstdockerrepo:${DOCKER_TAG}"
        }
      }
    }  
  stage('Deploy to k8s'){
    steps{
      sh "chmod +x changeTag.sh"
      withCredentials([string(credentialsId: 'k8s-cert', variable: 'k8sCert'), string(credentialsId: 'dockerPWD', variable: 'DockerPWD')]) {
        withKubeConfig(caCertificate: 'k8sCert', credentialsId: 'k8s-cred', namespace: 'nsl', serverUrl: 'https://192.168.0.194/k8s/clusters/c-bcpzb') {
            sh "./changeTag.sh ${DOCKER_TAG}"
            sh "docker login -u mbhaskar2005 -p ${DockerPWD}"
            sh "kubectl create secret docker-registry docksecrete --docker-server='https://index.docker.io/v1/' --docker-username='mbhaskar2005' --docker-password=${DockerPWD}"
            sh "kubectl apply -f nginx.yml"
        }
        echo "debug 2"
     }
    }
  }
}
}
def getDockerTag(){
    def tag  = sh script: 'git rev-parse --short=5 HEAD', returnStdout: true
    return tag
}

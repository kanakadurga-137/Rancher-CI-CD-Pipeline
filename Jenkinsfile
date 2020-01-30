pipeline {
  
  agent any 
  environment {
    DOCKER_TAG = getDockerTag()
  }
  
  stages {
    stage('Build Docker Image'){
      steps{
        sh "whoami"
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
      sh "sudo su"
      sh "chmod +x changeTag.sh"
      sh "./changeTag.sh ${DOCKER_TAG}"
      sh "kubectl apply -f pod.yml"
      sh "kubectl apply -f services.yml"
     
      echo "debug 2"
      }
    }
  }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse --short=5 HEAD', returnStdout: true
    return tag
}

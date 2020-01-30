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
      sh "chmod +x changeTag.sh"
      sh "./changeTag.sh ${DOCKER_TAG}"
      sh "kubectl -f pod.yml"
      sh "kubectl -f services.yml"
      
          try{
            echo "debug 2"
            sh "kubectl apply -f ."
            echo "debug 3"
            }catch(error){
              echo "debug 4"
              sh "kubectl create -f ."
              echo "debug 5"
            }
        }
      }
    }
    }
  }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse --short=5 HEAD', returnStdout: true
    return tag
}

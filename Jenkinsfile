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
      sshagent(['kops-machine']) {
        sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ec2-user@192.168.0.194:/home/ec2-user/"
        script{
          try{
            sh "ssh ec2-user@192.168.0.194 kubectl apply -f ."
            }catch(error){
              sh "ssh ec2-user@192.168.0.194 kubectl create -f ."
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

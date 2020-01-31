pipeline {
  
  agent any 
  environment {
    DOCKER_TAG = getDockerTag()
  }
  
  stages {
    stage('Build Docker Image'){
      steps{
        sh "whoami"
        sh "sudo su"
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
      withKubeConfig(caCertificate: '''-----BEGIN CERTIFICATE-----
MIIC7jCCAdagAwIBAgIBADANBgkqhkiG9w0BAQsFADAoMRIwEAYDVQQKEwl0aGUt
cmFuY2gxEjAQBgNVBAMTCWNhdHRsZS1jYTAeFw0yMDAxMjYxNjAyNDBaFw0zMDAx
MjMxNjAyNDBaMCgxEjAQBgNVBAoTCXRoZS1yYW5jaDESMBAGA1UEAxMJY2F0dGxl
LWNhMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuCrHf3IDGUnOGW8a
yq66NCe7jMgRMXYyVR2CbJG5mBYQPH6c/c+vCqS1bTqvgWoFxrRbPqySE8xJGVhU
XuifVpFhPgUpiDusOLCkhpZCJAlwYfmsvzyiVYQGW1YVQHKl9q0tF1+18tJVwxbV
rBcwYxO536eiqvSH/9dh6IZT7HGSKpV5xmd4vx16W2TFB1W3VHnsrM2tjOTWm8gW
hXEtjKoGcztHipXaa0n+NOn6DJ9PqtaSfTNYP6/bTspOcbaJTGQ8akpTLMI4uFWy
YBEsaw0wW0JYk87CWTwjbZ8vq+7nL3wXznzJfPz/7n2+1tNL52TkpcGCTp1Y1BJT
ppVeewIDAQABoyMwITAOBgNVHQ8BAf8EBAMCAqQwDwYDVR0TAQH/BAUwAwEB/zAN
BgkqhkiG9w0BAQsFAAOCAQEAZ16eb1rOu4I6AqXVqFOeZHbok3JMiJFJNtudt8IV
mTICg9S9g2pYQ7Wji79dUwQSeo0Xcm+wnrxCNwNvAsfJUafDrjJDebgVkU5FtDwQ
JXAfrj5ivaaTMkGR9r6OMFcoUa0iPjY7+sWPRckOs36Dr3uouzA3jTndEp4i5XqK
mnZPcRgstVlSvn5GIhcYXohGMez3eP3BwN1MxkRL6uH3d41ZB0xFEQo/ij6DMNFm
Z6I1v+qJos+S5/XLQxJVDAvWDa1GH9GZJtm9mMwrFYJ469IugtRymKwwcUbGeyCt
PdtrDFXEJY3vkDcg721//o/6Avu0BmHIg/VVggfousRHsg==
-----END CERTIFICATE-----''', clusterName: '', contextName: '', credentialsId: 'k8s-cred', namespace: 'nsl', serverUrl: 'https://192.168.0.194/k8s/clusters/c-bcpzb') {
        
        sh "./changeTag.sh ${DOCKER_TAG}"
        withCredentials([string(credentialsId: 'dockerPWD', variable: 'DockerPWD')]) {
          sh "kubectl create secret docker-registry docksecr --docker-server='DockerHub' --docker-username='mbhaskar2005' --docker-password=${DockerPWD}"
        }
        sh "kubectl apply -f node-app-pod.yml"
}
      echo "debug 2"
      }
    }
  }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse --short=5 HEAD', returnStdout: true
    return tag
}

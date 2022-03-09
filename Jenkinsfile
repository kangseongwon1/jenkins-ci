pipeline{
    agent any

    environment {
        dockerHubRegistry = 'skarltjr/k8s'
        dockerHubRegistryCredential = 'docker-hub'
    }

    stages {
        stage('check out application git branch'){
            steps {
                checkout scm
            }
            post {
                failure {
                    echo 'repository clone failure'
                }
                success {
                    echo 'repository clone success'
                }
            }
        }
        stage('build gradle') {
            steps {
                sh  './gradlew build'
                sh 'ls -al ./build'
            }
            post {
                success {
                    echo 'gradle build success'
                }
                failure {
                    echo 'gradle build failed'
                }
            }
        }
        stage('docker image build'){
            steps{
                sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}"
                sh "docker build . -t ${dockerHubRegistry}:latest"
            }
            post {
                    failure {
                      echo 'Docker image build failure !'
                    }
                    success {
                      echo 'Docker image build success !'
                    }
            }
        }
        stage('Docker Image Push') {
//             steps {
//                 withDockerRegistry([ credentialsId: dockerHubRegistryCredential, url: "" ]) {
//                     sh "docker push ${dockerHubRegistry}:${currentBuild.number}"
//                     sh "docker push ${dockerHubRegistry}:latest"
//
//                     sleep 10 /* Wait uploading */
//                 }
//             }
            steps {
                docker.withRegistry('https://registry.hub.docker.com',dockerHubRegistryCredential){
                    sh "docker push ${dockerHubRegistry}:${currentBuild.number}"
                    sh "docker push ${dockerHubRegistry}:latest"
                }
            }
            post {
                    failure {
                      echo 'Docker Image Push failure !'
                      sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}:latest"
                    }
                    success {
                      echo 'Docker image push success !'
                      sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                      sh "docker rmi ${dockerHubRegistry}:latest"
                    }
            }
        }


    }
}
pipeline{
    // agent any 
    agent{
        label "AGENT-1"
    }
    environment{
        
    }
    options{
        timeout(time: 10, unit: 'MINUTES'){
            disableConcurrentBuilds() 
        }
    }
   
    stages{
        stage("read the version"){
            steps{
                script{
                    def file= readJSON file: 'package.json'
                    version = file.version
                    echo "this is building space for catalogue"
                    echo "this is node version: ${version}"
                }     
            }
        }
        stage("install dependencies"){
            steps{
                sh "npm install"
            }
        }
        stage("build"){
            steps{
                withAWS(credentials: 'aws-credintails', region: 'us-east-1'){
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 832510228841.dkr.ecr.us-east-1.amazonaws.com
                        docker build -t roboshop/catalogue .
                        docker tag roboshop/catalogue:latest 832510228841.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:latest
                        docker push 832510228841.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:latest
                    """
                }
            }
        }
    }
    post{
        always{
            echo "cleaning work space"
            cleanWs()
        }
        
    }
}
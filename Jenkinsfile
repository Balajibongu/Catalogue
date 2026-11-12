pipeline{
    agent any 
    // agent{
    //     label {
    //         node = "AGENT-1"
    //     }
    // }
    stages{
        stage("build"){
            steps{
                script{
                    def file= readJSON file: 'package.json'
                    version = file.version
                    echo "this is building space for catalogue"
                    echo "this is node version: ${version}"
                }      // sh "npm install"
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
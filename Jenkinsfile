pipeline{
    agent any 
    // agent{
    //     label {
    //         node = "AGENT-1"
    //     }
    // }
    environment{
        script{
            def file= readJSON file: 'package.json'
            version = file.version
        }
    }
    stages{
        stage("build"){
            steps{
                echo "this is building space for catalogue"
                echo "this is node version: ${version}"
                    // sh "npm install"
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
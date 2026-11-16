pipeline{
    // agent any 
    agent{
        label "AGENT-1"
    }
    environment{
        name = "balaji"
    }
    options{
        timeout(time: 10, unit: 'MINUTES')
        disableConcurrentBuilds() 
    } 
    stages{
        stage("read the version"){
            steps{
                script{
                    def file= readJSON file: 'package.json'
                    def version = file.version
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
        stage("unit testing"){
            steps{
                sh "npm test"
            }
        }
        // stage("qualite policy"){
            
        // }

        stage('Dependabot Security Check') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'github-token',
                        variable: 'GITHUB_TOKEN'
                    )
                ])
                {
                    sh '''
                        set -eu

                        echo "Checking GitHub Dependabot alerts..."

                        curl -fsS -G \
                          -H "Accept: application/vnd.github+json" \
                          -H "Authorization: Bearer $GITHUB_TOKEN" \
                          -H "X-GitHub-Api-Version: 2022-11-28" \
                          --data-urlencode "state=open" \
                          --data-urlencode "severity=high,critical" \
                          --data-urlencode "per_page=100" \
                          https://api.github.com/repos/balajibongu/catalogue/dependabot/alerts \
                          -o dependabot-alerts.json

                        echo "Checking for HIGH or CRITICAL alerts..."

                        ALERT_COUNT=$(jq 'length' dependabot-alerts.json)

                        echo "Open HIGH/CRITICAL alerts found: $ALERT_COUNT"

                        if [ "$ALERT_COUNT" -gt 0 ]; then
                            echo "ERROR: High or Critical vulnerabilities found!"
                            jq -r '.[] |
                              "Alert #\\(.number): \\(.security_advisory.summary) | Severity: \\(.security_advisory.severity)"' dependabot-alerts.json
                            exit 1
                        else
                            echo "SUCCESS: No open HIGH or CRITICAL vulnerabilities."
                            echo "Proceeding with pipeline..."
                        fi
                    '''
                }
            }
        }
        stage("build"){
            steps{
                withAWS(credentials: 'aws-credentials', region: 'us-east-1')
                {
                    sh """
                        # docker build -t catalogue:latest .
                        docker images
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 832510228841.dkr.ecr.us-east-1.amazonaws.com
                        docker build -t 832510228841.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:latest .
                        # docker rmi -f catalogue:latest
                        docker images
                        docker push 832510228841.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:latest
                    """
                }
            }
        }
        stage("trivy scanning"){
            steps{
                sh """
                    trivy image \
                    --scanners vuln \
                    ---severity HIGH,CRITICAL\
                    --exit-code 1\
                    --pkg-types os \
                    832510228841.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:latest
                """
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
@Library('jenkins-shared-library') _

def configMap=[
    projectname= "roboshop",
    directory="Catalogue"
]

// echo "now we are executing the catalogue"
echo "now we are executing the catalogue in feature_branch"

if(${env.BRANCH_NAME}.equalsIgnoreCase("main")){
    echo "please folow the RP"
}
else{
    nodejenkins(configMap)
}
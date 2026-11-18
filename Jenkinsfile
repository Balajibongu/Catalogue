@Library('nodejs-lib') _

def configMap=[
    projectname= "roboshop",
    directory="catalogue"
]

echo "now we are executing the catalogue"

if(${env.BRANCH_NAME}.equalsIgnoreCase("main")){
    echo "please folow the RP"
}
else{
    nodejenkins(configMap)
}
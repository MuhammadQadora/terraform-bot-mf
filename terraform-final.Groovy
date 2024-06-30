pipeline {
    options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '5'))
    ansiColor('xterm')
    }

    parameters {
        choice(name: 'CHOICE', choices: ['apply','destroy'], description: 'Choose one')
    }
    agent {
        docker {
            label 'linux'
            image 'muhammadqadora/jenkins-inbound-agent:1.0'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'ref', value: '$.ref'],
      [key: 'pusher',value: '$.pusher.name'],
      [key: 'modifiedFile', value: '$.commits[0].modified[0]']
     ],

     causeString: 'Triggered on $ref',

     token: '', ///Remember to change this !!!!!!!!!!!!
     tokenCredentialId: 'terraform-bot-webhook-token',

     printContributedVariables: true,
     printPostContent: true,

     silentResponse: false,
     
     shouldNotFlatten: false,

     regexpFilterText: '$ref $modifiedFile',
     regexpFilterExpression: 'refs/heads/terraform-final-project tf.*'
    )
  }
    stages{
        stage('print parameters'){
            when {
                    expression { env.ref != null }
                }
            steps{
                script{
                echo "########################## ${pusher} ########################"
                echo "########################## ${BUILD_NUMBER} ##################"
                echo "########################## ${modifiedFile} ##################"
                echo "########################## stage name: ${STAGE_NAME} ####################"
                }
            }
        }
        stage('checkout from terraform-final-project'){
            steps{
                println("########################## stage name: ${env.STAGE_NAME} ####################")
                checkout changelog: false, poll: false, scm: scmGit(branches: [[name: '*/terraform-final-project']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/MuhammadQadora/terraform-bot-mf']])
                sh 'echo Succesfuly checkedout from github'
            }
        }
        stage('terraform init and plan'){
            steps{
                script {
                println("########################## stage name: ${env.STAGE_NAME} ####################")
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                sh '''
                #!/bin/bash
                terraform -chdir=tf init
                terraform -chdir=tf plan --var-file=ap-northeast-1.tfvars
                '''
                    }
                }
            }
        }
        stage('terraform apply or destroy'){
            steps{
                script {
                println("########################## stage name: ${env.STAGE_NAME} ####################")
                println("############################ ${params.CHOICE} was used")
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        #!/bin/bash
                        terraform -chdir=tf $CHOICE --var-file=ap-northeast-1.tfvars --auto-approve
                        '''
                 }
                }
            }
        }
        stage("Artifacts"){
        steps {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          script {
            println("########################## stage name: ${env.STAGE_NAME} ####################")
            sh 'terraform -chdir=tf output > TerraformOutput.txt'
            archiveArtifacts allowEmptyArchive: true, artifacts: '**/**.txt', followSymlinks: false
            }
          }
        }
        }
    }
    post {
    always {
      cleanWs()
      emailext attachLog: true, body: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:\nCheck console output at $BUILD_URL to view the results.', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'memomq70@gmail.com, firas.narani.1999@outlook.com'
    }
  }
}
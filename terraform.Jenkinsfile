pipeline {
  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '5'))
    ansiColor('xterm')
  }
  parameters {
    string(name: 'region',defaultValue: 'ap-northeast-1', description: 'The region to deploy to')
    string(name: 'terraformWorkspace', defaultValue: 'ap-northeast-1', description: 'terraform workspace')
    choice(name: 'CHOICE', choices: ['apply','destroy'], description: 'Choose one')
  }
  agent {
    docker {
      label 'linux'
      image 'muhammadqadora/jenkins-inbound-agent'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
  triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'ref', value: '$.ref'],
      [key: 'pusher',value: '$.pusher.name']
     ],

     causeString: 'Triggered on $ref',

     token: '123456',
     tokenCredentialId: '',

     printContributedVariables: true,
     printPostContent: true,

     silentResponse: false,
     
     shouldNotFlatten: false,

     regexpFilterText: '$ref',
     regexpFilterExpression: 'refs/heads/main'
    )
  }
  environment {
    TF_VAR_ec2_public_key = credentials('ec2-public-key')
  }
  stages {
    stage('print params') {
      when {
        expression { env.ref != null } // Run only if triggered by webhook
      }
      steps {
         script{
           echo "${env.ref}"
           echo "=====================================${STAGE_NAME}====================================="
           echo "=====================================${BUILD_NUMBER}====================================="
           echo "=====================================${env.pusher}====================================="
           echo "=====================================${env.region}==============================="
        }
      }
    }
    stage('github checkout') {
      steps {
        script {
          echo "=====================================${STAGE_NAME}====================================="
          checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/MuhammadQadora/terraform-bot-mf']])
          echo 'checkedout from github...'
        }
      }
    }
    stage('Terraform init'){
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        script {
          echo "=====================================${STAGE_NAME}====================================="
          sh 'terraform -chdir=tf init'
          }
        }
      }
    }
    stage('Terraform Plan'){
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        script {
          echo "=====================================${STAGE_NAME}====================================="
          sh """
            #!/bin/bash
            echo ${params.terraformWorkspace}
            terraform -chdir=tf workspace select ${params.terraformWorkspace}
            echo switched to ${params.terraformWorkspace}
            terraform -chdir=tf plan -var-file=${params.region}.tfvars
            """
          }
        }
      }
    }
    stage("Terraform apply or destroy"){
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        script {
          sh """
            #!/bin/bash
            echo doing a ${params.CHOICE}
            terraform -chdir=tf workspace show
            terraform -chdir=tf ${params.CHOICE} -var-file=${params.region}.tfvars --auto-approve
            """
          }
        }
      }
    }
  }
  post {
    always {
      emailext attachLog: true, body: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:\nCheck console output at $BUILD_URL to view the results.', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'memomq70@gmail.com, firas.narani.1999@outlook.com'
    }
  }
} 

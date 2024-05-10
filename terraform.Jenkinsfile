pipeline {
  agent any
  triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'ref', value: '$.ref']
     ],

     causeString: 'Triggered on $ref',

     token: '123456',
     tokenCredentialId: '',

     printContributedVariables: true,
     printPostContent: true,

     silentResponse: false,
     
     shouldNotFlatten: false,

     regexpFilterText: '$ref',
     regexpFilterExpression: ''
    )
  }
  stages {
    stage('Some step') {
      steps {
         script{
          sh 'echo $ref ok'   
         }
      }
    }
  }
}
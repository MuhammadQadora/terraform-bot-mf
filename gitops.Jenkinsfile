pipeline{
    agent {
        kubernetes {}
    }
    options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '2'))
    ansiColor('xterm')
    }
    parameters {
         string(name: 'region',defaultValue: 'ap-northeast-1', description: 'The region to deploy to')
         string(name: 'cluster_name',defaultValue: 'mf-cluster', description: 'the cluster name')
         choice(name: 'CHOICE', choices: ['apply','delete'], description: 'Choose one')
    }


    stages{
        stage('checkout from GitOps repo'){
        steps {
            checkout changelog: false, poll: false, scm: scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/MuhammadQadora/GitOps']])
            echo "checkout from GitOps repo"
        }
       }
       stage('initialize CoreApps'){
            when { expression {params.CHOICE == 'apply'}}
        steps{
             withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'),
             usernamePassword(credentialsId: 'github-token', passwordVariable: 'token', usernameVariable: 'user'),file(credentialsId: 'sealed-cert', variable: 'myfile')]){
            script{
                    sh '''
                    #!/bin/bash
                    echo "changing ingress controller values..."
                    vpc_id=$(aws ec2 describe-vpcs --filter 'Name=tag:Name,Values=vpc-mf' --region $region --query 'Vpcs[*].VpcId' --output text)
                    sed -i "s/clusterName: .*/clusterName: $cluster_name/" CoreApps/ingress-controller-app.yaml
                    sed -i "s/vpcId: .*/vpcId: $vpc_id/" CoreApps/ingress-controller-app.yaml
                    sed -i "s/region: .*/region: $region/" CoreApps/ingress-controller-app.yaml
                    echo "done.."


                    echo "changing cluster controller values.."
                    sed -i "s/awsRegion: .*/awsRegion: $region/" CoreApps/cluster-controller-app.yaml
                    sed -i "s/clusterName: .*/clusterName: $cluster_name/" CoreApps/cluster-controller-app.yaml
                    echo "done..."


                    echo "changing external dns values..."
                    sed -i "s/region: .*/region: $region/" CoreApps/external-dns-app.yaml
                    echo "done..."


                    echo "Applying files"
                    aws eks update-kubeconfig --name $cluster_name --region $region
                    kubectl create -f \
                        "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v0.37.0/pkg/apis/crds/karpenter.sh_nodepools.yaml" || true
                    kubectl create -f \
                        "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v0.37.0/pkg/apis/crds/karpenter.k8s.aws_ec2nodeclasses.yaml" || true
                    kubectl create -f \
                        "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v0.37.0/pkg/apis/crds/karpenter.sh_nodeclaims.yaml" || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusagents.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_scrapeconfigs.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml || true
                    kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.75.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml || true
                    kubectl apply -f nodepool.yaml
                    kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
                    envsubst < repos-secret.yaml | kubectl $CHOICE -f -
                    kubectl $CHOICE -f core-app-controller.yaml
                    kubectl $CHOICE -f $myfile
                    kubectl $CHOICE -f ingress-app.yaml
                    while true;do kubectl get ns fluentd elasticsearch && break ;done 1> /dev/null 2> /dev/null
                    kubectl $CHOICE -f fluent-sealed-secret.yaml
                    kubectl $CHOICE -f elastic-sealedsecret.yaml
                    '''
                }
             }
        }
       }
       stage('initialize applications'){
            when { expression {params.CHOICE == 'apply'}}
           steps{
               withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                   script {
                       sh '''
                       #!/bin/bash
                       aws eks update-kubeconfig --name $cluster_name --region $region
                       kubectl get ns dev || kubectl create ns dev
                       kubectl get ns prod || kubectl create ns prod
                       kubectl delete secret ecr --ignore-not-found -n dev
                       kubectl delete secret ecr --ignore-not-found -n prod
                       id=$(aws sts get-caller-identity --query Account --output text)
                       set +x
                       kubectl create secret docker-registry ecr \
                        --docker-server=$id.dkr.ecr.us-east-1.amazonaws.com \
                        --docker-username=AWS \
                        --docker-password=$(aws ecr get-login-password --region us-east-1) -n dev || echo exists
                        
                       kubectl create secret docker-registry ecr \
                        --docker-server=$id.dkr.ecr.us-east-1.amazonaws.com \
                        --docker-username=AWS \
                        --docker-password=$(aws ecr get-login-password --region us-east-1) -n prod || echo exists
                        
                       kubectl create secret docker-registry docker-credentials \
                        --docker-server=$id.dkr.ecr.us-east-1.amazonaws.com \
                        --docker-username=AWS \
                        --docker-password=$(aws ecr get-login-password --region us-east-1) -n default || echo exists
                
                       set -x
                       kubectl $CHOICE -f dev-app-controller.yaml
                       kubectl $CHOICE -f prod-app-controller.yaml
                       '''
                   }
               }
           }
       }
       stage('trigger git push pipeline'){
        when { expression {params.CHOICE == 'apply'}}
        steps{
            withCredentials([usernamePassword(credentialsId: 'github-token', passwordVariable: 'token', usernameVariable: 'guser')]) {
                script {
                    sh '''
                    #!/bin/bash
                    git config --global user.name "$guser"
                    git config --global user.email "memomq70@gmail.com"
                    #git config --global --add safe.directory /home/ubuntu/jenkins_home/workspace/initialize-applications
                    git remote set-url origin https://$guser:$token@github.com/MuhammadQadora/GitOps
                    export check=$(git status | grep clean)
                    if [ "$check" = "nothing to commit, working tree clean" ];then echo yes && exit 0;fi
                    git checkout main
                    git add .
                    git commit -m "Commit by Jenkins: pushed changes build number is $BUILD_NUMBER"
                    git push origin main
                    '''
                }
            }
        }
       }
       stage('delete resources'){
            when { expression {params.CHOICE == 'delete'}}
           steps{
               withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Terraform-aws-creds', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]){
                   script {
                       sh '''
                       #!/bin/bash
                       aws eks update-kubeconfig --name $cluster_name --region $region
                       kubectl $CHOICE -f ingress-app.yaml || true
                       wait
                       kubectl $CHOICE -f dev-app-controller.yaml || true
                       wait
                       kubectl $CHOICE -f prod-app-controller.yaml || true
                       wait
                       kubectl $CHOICE -f core-app-controller.yaml || true
                       wait
                       '''
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
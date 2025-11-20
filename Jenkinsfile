pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.9.0'
            args '-u root:root --entrypoint=""'
        }
    }

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
    }

    parameters {
        booleanParam(
            name: 'AUTO_APPROVE',
            defaultValue: false,
            description: 'Skip approval and auto apply Terraform'
        )
    }

    stages {

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-creds']]) {

                    sh "terraform init -input=false"
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh "terraform validate"
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-creds']]) {

                    sh "terraform plan -out=tfplan"
                }
            }
        }

        stage('Approval') {
            when {
                expression { !params.AUTO_APPROVE }
            }
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        input "Apply Terraform EKS deployment?"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-creds']]) {

                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
    }

    post {
        always { cleanWs() }
    }
}

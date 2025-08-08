pipeline {
    agent any
    tools {
        maven 'maven3.9.11'
    }
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        DOCKER_SERVER_IP      = "44.202.143.20"
        REMOTE_USER           = "ubuntu"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/Praveen230389/Public-One.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
                sh 'terraform plan'
                sh 'terraform validate'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Docker Image Build') {
            steps {
                sh 'docker build -t ashokit/mavenwebapp .'
            }
        }

        stage('Execute playbook') {
            steps {
                ansiblePlaybook credentialsId: 'ssh', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: '/home/ubuntu/workspace/kubernetes/playbook.yaml', vaultTmpPath: ''
            }
        }
        
        stage('SonarQube Analysis') {
            environment {
                SONAR_HOST_URL = 'http://44.205.246.11:9000' // Replace with your SonarQube URL
                SONAR_AUTH_TOKEN = credentials('SonarQubetoken') // Store your token in Jenkins credentials
            }
            steps {
                sh 'mvn sonar:sonar -Dsonar.projectKey=sample_project -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN'
            }
        }
        stage('k8s deployment') {
            steps {
                sh 'kubectl apply -f k8s-deploy.yaml'
            }
        }
    }
}

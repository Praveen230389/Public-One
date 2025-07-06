pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-creds')
    AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', credentialsId: 'github-pat', url: 'https://github.com/Praveen230389/Public-One.git'
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('') {
          sh '''
            cd .
            terraform init
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Generate Inventory') {
      steps {
        sh '''
          terraform output -raw aws_instance_web_public_ip > inventory.ini
          echo "[web]" > hosts.ini
          echo $(terraform output -raw aws_instance_web_public_ip) >> hosts.ini
        '''
      }
    }

    stage('Ansible Configure') {
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'ansible-ssh-key',
          keyFileVariable: 'SSH_KEY'
        )]) {
          sh '''
            ansible-playbook -i hosts.ini site.yml --private-key=$SSH_KEY
          '''
        }
      }
    }
  }
}

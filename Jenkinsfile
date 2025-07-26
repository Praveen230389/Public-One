pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'us-east-1' // adjust if needed
  }

  options {
    skipDefaultCheckout(true)
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Setup AWS Credentials') {
      environment {
        // Inject AWS credentials from Jenkins Credentials (secret text)
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
      }
      steps {
        echo 'AWS credentials set from Jenkins credentials store.'
      }
    }

    stage('Terraform Init & Validate') {
      steps {
        sh '''
          terraform init
          terraform validate
        '''
      }
    }

    stage('Terraform Plan & Apply') {
      steps {
        sh '''
          terraform plan
          terraform apply -auto-approve
        '''
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh 'ansible-playbook site.yml'
      }
    }

    stage('Docker Build & Run') {
      steps {
        sh '''
          docker stop sonarcontainer || true
          docker rm sonarcontainer || true
          docker rmi sonarimage || true

          docker build -t sonarimage .
          docker run -d -p 8085:80 --name sonarcontainer sonarimage
        '''
      }
    }

    stage('SonarQube Scan') {
      environment {
        // Pulls global SonarQube config name
        SONARQUBE_SCANNER_HOME = tool 'SonarScanner' // Must match Jenkins global tool name
      }
      steps {
        withSonarQubeEnv('MySonarQubeServer') {
          sh '''
            ${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner \
              -Dsonar.projectKey=myproject \
              -Dsonar.sources=. \
              -Dsonar.host.url=$SONAR_HOST_URL \
              -Dsonar.login=$SONAR_AUTH_TOKEN
          '''
        }
      }
    }
  }
}

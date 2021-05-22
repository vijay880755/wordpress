pipeline {
    agent any

    stages {
        stage('Clone WordPress Repository') {
            steps {
            git 'https://github.com/vijay880755/wordpress.git'
            }
        }
        stage('Building Docker Stack'){
            steps{
                sh 'docker -v'
                sh 'chmod 755 BuildScript.sh'
                sh './BuildScript.sh ${BUILD_NUMBER}'
            }
            
        }
        stage('Deploying to Fargate'){
            steps{
                sh 'cd terraform && /usr/local/bin/terraform init && /usr/local/bin/terraform validate && /usr/local/bin/terraform plan -input=false && /usr/local/bin/terraform apply -var="tag=wordpress_${BUILD_NUMBER}" -auto-approve'
            }
        }
    }
}
